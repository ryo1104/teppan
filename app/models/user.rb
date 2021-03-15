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
  # validate  :nickname
  validate  :image_content_type, if: :was_attached?
  validate  :gender_code_check
  validate  :age_check
  # validates :introduction, length: { maximum: 800 }
  validate  :stripe_cus_id_check
  validates :follows_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :unregistered, inclusion: { in: [true, false] }

  def self.find_or_create_for_oauth(auth)
    auth_check = auth_check(auth)
    return [false, auth_check[1]] unless auth_check[0]

    email = if auth.provider == 'twitter'
              auth.info.name + '@twitter-hoge.com' # twitter APIでPrivacyPolicy等の設定をすればauth.info.emailから取得可能になる
            else
              auth.info.email
            end

    gender = if auth.info.gender == 'male'
               1
             elsif auth.info.gender == 'female'
               2
             end

    user = User.find_by(email: email)
    unless user
      user = User.new(email: email,
                      provider: auth.provider,
                      uid: auth.uid,
                      nickname: auth.info.name,
                      password: Devise.friendly_token[0, 20],
                      gender: gender)
      user.skip_confirmation!
      user.save
    end
    user
  end

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
    Topic.includes({ user: [image_attachment: :blob] }, :netas).where(id: i_topicids).order('created_at DESC')
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

  def self.details_from_ids(ids)
    users = User.where(id: ids)
    if users.present?
      users_hash = {}
      users.each do |user|
        users_hash.merge!({ user.id => { 'nickname' => user.nickname } })
      end
      users_hash
    else
      false
    end
  end

  # def get_sold_netas_info
  #   trades = Trade.where(seller_id: id, tradeable_type: 'Neta').order('created_at DESC')

  #   if trades.present?

  #     neta_ids = []
  #     buyer_ids = []
  #     trades.each do |trade|
  #       buyer_ids << trade.buyer_id
  #       neta_ids << trade.tradeable_id
  #     end
  #     buyer_ids.uniq!
  #     neta_ids.uniq!

  #     buyers = User.where(id: buyer_ids)
  #     netas = Neta.where(id: neta_ids)
  #     reviews = Review.where(neta_id: neta_ids)

  #     buyers_hash = {}
  #     buyers.each do |buyer|
  #       buyers_hash.merge!({ buyer.id => { 'nickname' => buyer.nickname } })
  #     end
  #     neta_hash = {}
  #     netas.each do |neta|
  #       neta_hash.merge!({ neta.id => { 'title' => neta.title } })
  #     end
  #     review_hash = {}
  #     reviews.each do |review|
  #       review_hash.merge!({ 'neta_' + review.neta_id.to_s + '_user_' + review.user_id.to_s => { 'rate' => review.rate } })
  #     end

  #     sold_netas_info = []
  #     trades.each do |trade|
  #       rate = if review_hash.has_key?('neta_' + trade.tradeable_id.to_s + '_user_' + trade.buyer_id.to_s)
  #               review_hash['neta_' + trade.tradeable_id.to_s + '_user_' + trade.buyer_id.to_s]['rate']
  #             end
  #       sold_netas_info << {
  #         'traded_at' => trade.created_at,
  #         'title' => neta_hash[trade.tradeable_id]['title'],
  #         'price' => trade.price,
  #         'buyer_id' => trade.buyer_id,
  #         'buyer_nickname' => buyers_hash[trade.buyer_id]['nickname'],
  #         'review_rate' => rate
  #       }
  #     end
  #     [true, sold_netas_info]
  #   else
  #     [false, "No sold netas found for user_id #{id}"]
  #   end
  # end

  def can_unregister
    if get_balance[0]
      [false, 'User cash balance remaining']
    else
      [true, '']
    end
  end

  def self.auth_check(auth)
    return [false, 'auth is empty'] if auth.blank?

    providers = ['yahoojp', 'twitter', 'google_oauth2']
    return [false, 'unknown provider'] unless providers.include?(auth['provider'])

    [true, nil]
  end

  private_class_method :auth_check

  private

  def image_content_type
    extension = ['image/png', 'image/jpg', 'image/jpeg']
    errors.add(:image, I18n.t('errors.messages.unsupported_file_type')) unless image.content_type.in?(extension)
  end

  def was_attached?
    image.attached?
  end

  def gender_code_check
    if gender.present?
      errors.add(:gender, 'Invalid gender code') if gender < 1 || gender > 3
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
