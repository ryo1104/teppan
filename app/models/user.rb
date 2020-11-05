class User < ApplicationRecord
  include StripeUtils

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable,
         :trackable, :omniauthable, omniauth_providers: %i[google_oauth2 twitter yahoojp]

  has_many  :topics, -> { order('netas_count DESC') }
  has_many  :netas, -> { order('average_rate DESC') }
  has_many  :pageviews,  -> { order('created_at DESC') }
  has_many  :bookmarks,  -> { order('created_at DESC') }
  has_many  :hashtag_hits, -> { order('created_at DESC') }
  has_many  :comments
  has_many  :follows
  has_many  :reviews
  has_many  :violations
  has_one   :stripe_account
  has_one_attached :image
  has_rich_text :introduction
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validate  :nickname
  validate  :image_content_type, if: :was_attached?
  validate  :gender_code_check
  validate  :age_check
  # validates :introduction, length: { maximum: 800 }
  validate  :stripe_cus_id_check
  validates :follows_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :unregistered, inclusion: { in: [true, false] }

  def avatar
    image if image.attached?
  end

  def age
    if birthdate.present?
      date_format = '%Y%m%d'
      # Rubyは整数同士の除算は小数部は切り捨てられるため、floorは不要
      age = (Time.zone.today.strftime(date_format).to_i - birthdate.strftime(date_format).to_i) / 10_000

      age if age > 0
    else
      ' - '
    end
  end

  def gender_str
    if gender.present?
      if gender == 1
        '男性'
      elsif gender == 2
        '女性'
      else
        ' - '
      end
    else
      ' - '
    end
  end

  def temp_nickname
    email.split('@')[0] if email.present?
  end

  def self.find_or_create_for_oauth(auth)
    email = if auth.provider == 'twitter'
              auth.info.name + '@twitter-hoge.com' # twitter APIでPrivacyPolicy等の設定をすればauth.info.emailから取得可能になる
            else
              auth.info.email
            end

    user = User.find_by(email: email)
    unless user
      user = User.new(email: email,
                      provider: auth.provider,
                      uid: auth.uid,
                      nickname: auth.info.name,
                      password: Devise.friendly_token[0, 20])
      user.skip_confirmation!
      user.save
    end
    user
  end

  def following_users
    following_user_ids = []
    follows = Follow.where(follower_id: id)
    follows.each do |follow|
      following_user_ids << follow.user_id
    end
    f_users = User.includes(:netas, image_attachment: :blob).where(id: following_user_ids.uniq)
    f_users
  end

  def following_users_count
    Follow.where(follower_id: id).count
  end

  def followed_users
    followed_user_ids = []
    follows = self.follows
    follows.each do |follow|
      followed_user_ids << follow.follower_id
    end
    f_users = User.includes(:netas, image_attachment: :blob).where(id: followed_user_ids.uniq)
    f_users
  end

  def is_followed_by(user_id)
    follow = Follow.find_by(user_id: id, follower_id: user_id)
    if follow.present?
      true
    else
      false
    end
  end

  def is_blocked_by(user_id)
    violation = Violation.find_by(user_id: id, reporter_id: user_id)
    if violation.present?
      true
    else
      false
    end
  end

  def average_rate
    Neta.average_rate(netas)
  end

  def free_netas
    netas.includes(:reviews).where(price: 0)
  end

  def free_reviewed_netas
    netas.includes(:reviews).where(price: 0).where.not(average_rate: 0)
  end

  def premium_user
    netas = free_reviewed_netas
    free_neta_count = netas.count
    avg = Neta.average_rate(netas)
    if free_neta_count >= 3 && avg >= 3
      [true, avg, free_neta_count]
    else
      [false, avg, free_neta_count]
    end
  end

  def premium_qualified
    if premium_user[0] && stripe_account.present?
      stripe_account.status == 'verified'
    else
      false
    end
  end

  def self.bought_netas(bought_trades)
    b_netaids = []
    bought_trades.each do |trade|
      b_netaids << trade.tradeable_id if trade.tradeable_type == 'Neta'
    end
    Neta.includes({ user: [image_attachment: :blob] }, :hashtags).where(id: b_netaids)
  end

  def bookmarked_netas
    i_netaids = []
    bookmarks.each do |bookmark|
      i_netaids << bookmark.bookmarkable_id if bookmark.bookmarkable_type == 'Neta'
    end
    Neta.includes({ user: [image_attachment: :blob] }, :hashtags).where(id: i_netaids).order('created_at DESC')
  end

  def bookmarked_topics
    i_topicids = []
    bookmarks.each do |bookmark|
      i_topicids << bookmark.bookmarkable_id if bookmark.bookmarkable_type == 'Topic'
    end
    Topic.includes([header_image_attachment: :blob], { user: [image_attachment: :blob] }, :netas).where(id: i_topicids).order('created_at DESC')
  end

  def get_customer
    if stripe_cus_id.present?
      begin
        customer = JSON.parse(Stripe::Customer.retrieve(stripe_cus_id).to_s)
      rescue StandardError => e
        return [false, "Stripe error - #{e.message}"]
      end
      if customer['id'].present?
        [true, customer]
      else
        [false, 'customer data does not exist']
      end
    else
      [false, 'stripe_cus_id is blank']
    end
  end

  def get_cards
    if stripe_cus_id.present?
      begin
        cards = JSON.parse(Stripe::Customer.list_sources(stripe_cus_id, { limit: 3, object: 'card' }).to_s)
      rescue StandardError => e
        return [false, "Stripe error - #{e.message}"]
      end
      if cards['data'].present?
        [true, cards]
      else
        [false, 'cards list does not exist']
      end
    else
      [false, 'stripe_cus_id is blank']
    end
  end

  def get_card_details(card_id)
    if stripe_cus_id.present?
      if card_id.present?
        begin
          customer = Stripe::Customer.retrieve(stripe_cus_id)
          card = JSON.parse(customer.sources.retrieve(card_id).to_s)
        rescue StandardError => e
          return [false, "Stripe error - #{e.message}"]
        end
        if card['object'] == 'card'
          if card['customer'] == stripe_cus_id
            [true, card]
          else
            [false, "customer_id on card is #{card['customer']} does not match user.stripe_cus_id #{stripe_cus_id}"]
          end
        else
          [false, 'card data does not exist']
        end
      else
        [false, 'card_id is blank']
      end
    else
      [false, 'stripe_cus_id is blank']
    end
  end

  def add_card(token)
    if stripe_cus_id.present?
      if token.present?
        begin
          card = JSON.parse(Stripe::Customer.create_source(stripe_cus_id, { source: token }).to_s)
        rescue StandardError => e
          return [false, "Stripe error - #{e.message}"]
        end
      else
        return [false, 'token is blank']
      end
    else
      return [false, 'stripe_cus_id is blank']
    end

    chg_default_card_res = change_default_card(card['id'])
    if chg_default_card_res[0]
      [true, card]
    else
      [false, "error updating default card : #{chg_default_card_res[1]}"]
    end
  end

  def change_default_card(card_id)
    if card_id.present?
      cards = get_cards
      if cards[0]
        card_exists = false
        cards[1]['data'].each do |card_obj|
          card_exists = true if card_obj['id'] == card_id
        end
        return [false, 'card does not exist with this user'] unless card_exists
      else
        return [false, "failed to get cards : #{cards[1]}"]
      end

      begin
        customer = JSON.parse(Stripe::Customer.update(stripe_cus_id, { default_source: card_id }).to_s)
      rescue StandardError => e
        return [false, "Stripe error - #{e.message}"]
      end

      if customer['id'].present?
        [true, customer]
      else
        [false, 'customer not present in results']
      end
    else
      [false, 'card_id is blank']
    end
  end

  def create_cus_from_card(token)
    if token.present?
      begin
        customer = JSON.parse(Stripe::Customer.create({ name: nickname, source: token, email: email }).to_s)
      rescue StandardError => e
        return [false, "Stripe error - #{e.message}"]
      end
      if customer['id'].present?
        update!(stripe_cus_id: customer['id'])
        [true, customer]
      else
        [false, 'customer not present in results']
      end
    else
      [false, 'token is blank']
    end
  end

  def get_balance
    if stripe_account.present?
      res = stripe_account.get_balance
      if res[0]
        if res[1]['available'][0]['amount'].present?
          [true, res[1]['available'][0]['amount']]
        else
          [false, "failed to retrieve user's available balance"]
        end
      else
        [false, "failed to retrieve user's balance info : #{res[1]}"]
      end
    else
      [false, "user's account does not exist"]
    end
  end

  def set_source(charge_params)
    if charge_params[:stripeToken].present? # 新規カードを使用
      if stripe_cus_id.present?
        card_res = add_card(charge_params[:stripeToken]) # 新規カードを追加し、Cardを返す
        if card_res[0]
          [true, card_res[1]]
        else
          [false, "failed to add card : #{card_res[1]}"]
        end
      else
        customer_res = create_cus_from_card(charge_params[:stripeToken]) # 新規Customerを作成、カードをセットしCustomerを返す
        if customer_res[0]
          [true, customer_res[1]]
        else
          [false, "failed to set card to customer : #{customer_res[1]}"]
        end
      end

    elsif charge_params[:card_id].present? # 既存カードを使用
      if stripe_cus_id.present?
        customer_res = change_default_card(charge_params[:card_id]) # 既存カードをセットしCustomerを返す
        if customer_res[0]
          [true, customer_res[1]]
        else
          [false, "failed to change card : #{customer_res[1]}"]
        end
      else
        [false, 'stripe_cus_id is blank']
      end

    elsif charge_params[:user_points].present? # ポイントを使用
      if stripe_account.present?
        if charge_params[:charge_amount].present?
          user_points = charge_params[:user_points].to_i
          charge_amount = charge_params[:charge_amount].to_i
          if user_points >= charge_amount
            account_res = stripe_account.get_connect_account
            if account_res[0]
              [true, account_res[1]] # Account infoを返す
            else
              [false, "failed to get stripe account : #{account_res[1]}"]
            end
          else
            [false, 'insufficient points']
          end
        else
          [false, 'charge amount does not exist']
        end
      else
        [false, 'user account does not exist']
      end

    else
      [false, 'no valid source exists']
    end
  end

  def get_sold_netas_info
    trades = Trade.where(seller_id: id, tradeable_type: 'Neta').order('created_at DESC')

    if trades.present?

      neta_ids = []
      buyer_ids = []
      trades.each do |trade|
        buyer_ids << trade.buyer_id
        neta_ids << trade.tradeable_id
      end
      buyer_ids.uniq!
      neta_ids.uniq!

      buyers = User.where(id: buyer_ids)
      netas = Neta.where(id: neta_ids)
      reviews = Review.where(neta_id: neta_ids)

      buyers_hash = {}
      buyers.each do |buyer|
        buyers_hash.merge!({ buyer.id => { 'nickname' => buyer.nickname } })
      end
      neta_hash = {}
      netas.each do |neta|
        neta_hash.merge!({ neta.id => { 'text' => neta.title } })
      end
      review_hash = {}
      reviews.each do |review|
        review_hash.merge!({ 'neta_' + review.neta_id.to_s + '_user_' + review.user_id.to_s => { 'rate' => review.rate } })
      end

      sold_netas_info = []
      trades.each do |trade|
        rate = if review_hash.has_key?('neta_' + trade.tradeable_id.to_s + '_user_' + trade.buyer_id.to_s)
                 review_hash['neta_' + trade.tradeable_id.to_s + '_user_' + trade.buyer_id.to_s]['rate']
               end
        sold_netas_info << {
          'traded_at' => trade.created_at,
          'text' => neta_hash[trade.tradeable_id]['text'],
          'price' => trade.price,
          'buyer_id' => trade.buyer_id,
          'buyer_nickname' => buyers_hash[trade.buyer_id]['nickname'],
          'review_rate' => rate
        }
      end
      [true, sold_netas_info]
    else
      [false, "No sold netas found for user_id #{id}"]
    end
  end

  def can_unregister
    if get_balance[0]
      [false, 'User cash balance remaining']
    else
      [true, '']
    end
  end

  private

  # Custom Validations

  def image_content_type
    extension = ['image/png', 'image/jpg', 'image/jpeg']
    errors.add(:image, 'の拡張子はサポートされていません。') unless image.content_type.in?(extension)
  end

  def was_attached?
    image.attached?
  end

  def gender_code_check
    if gender.present?
      errors.add(:gender, 'Invalid gender code') if gender < 0 || gender > 3
    end
  end

  def age_check
    if birthdate.present?
      errors.add(:birthdate, '：１３歳未満はご利用できません。') if birthdate > Time.zone.today.prev_year(13)
    end
  end

  def stripe_cus_id_check
    if stripe_cus_id.present?
      errors.add(:stripe_cus_id, 'invalid stripe_cus_id') unless stripe_cus_id.starts_with? 'cus_'
    end
  end
end
