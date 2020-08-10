class User < ApplicationRecord
  include StripeUtils
  include JpPrefecture
  
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable
  has_many  :topics, ->{ order("netas_count DESC") }
  has_many  :netas, ->{ order("average_rate DESC") }
  has_many  :pageviews,  ->{ order("created_at DESC") }
  has_many  :bookmarks,  ->{ order("created_at DESC") }
  has_many  :hashtag_hits,  ->{ order("created_at DESC") }
  has_many  :comments
  has_many  :follows
  has_many  :reviews
  has_many  :violations
  has_one   :authorization
  has_one   :subscription
  has_one   :account
  has_one   :externalaccount, :through => :account
  has_one   :idcard, :through => :account
  has_one_attached :image
  has_rich_text   :introduction
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validate  :image_content_type, if: :was_attached?
  validate  :gender_code_check
  validate  :prefecture_code_check
  validate  :age_check
  validates :introduction, length: { maximum: 800 }
  validate  :stripe_cus_id_check
  validates :follows_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  jp_prefecture :prefecture_code
  
  def avatar
    if self.image.attached?
      return self.image
    else
      return nil
    end
  end
  
  def age
    if self.birthdate.present?
      date_format = "%Y%m%d"
      #Rubyは整数同士の除算は小数部は切り捨てられるため、floorは不要
      age = (Time.zone.today.strftime(date_format).to_i - self.birthdate.strftime(date_format).to_i) / 10000
      
      if age > 0
        return age
      else
        return nil
      end
    else
      return " - "
    end
  end
  
  def gender_str
    if self.gender.present?
      if self.gender == 1
        return "男性"
      elsif self.gender == 2
        return "女性"
      else
        return " - "
      end
    else
      return " - "
    end
  end
  
  def prefecture_name
    name = JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
    if name.present?
      return name
    else
      return " - "
    end
  end
  
  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end
  
  def temp_nickname
    if self.email.present?
      self.email.split('@')[0]
    else
      return nil
    end
  end
  
  def self.create_from_auth(auth_inputs)
    if auth_inputs.present?
      auth_inputs.merge!(password: Devise.friendly_token[0,20])    
      user = self.new(auth_inputs)
      if user.save
        return [true, user]
      else
        return [false, "failed to create user. #{user.error} "]
      end
    else
      return [false, "auth_inputs is empty"]
    end
  end
  
  def following_users
    following_user_ids = []
    follows = Follow.where(follower_id: self.id)
    follows.each do |follow|
      following_user_ids << follow.user_id
    end
    f_users = User.includes(:netas, image_attachment: :blob).where(id: following_user_ids.uniq)
    return f_users
  end
  
  def following_users_count
    return Follow.where(follower_id: self.id).count
  end
  
  def followed_users
    followed_user_ids = []
    follows = self.follows
    follows.each do |follow|
      followed_user_ids << follow.follower_id
    end
    f_users = User.includes(:netas, image_attachment: :blob).where(id: followed_user_ids.uniq)
    return f_users
  end
  
  def is_followed_by(user_id)
    follow = Follow.find_by(user_id: self.id, follower_id: user_id)
    if follow.present?
      return true
    else
      return false
    end
  end
  
  def is_blocked_by(user_id)
    violation = Violation.find_by(user_id: self.id, reporter_id: user_id)
    if violation.present?
      return true
    else
      return false
    end
  end
  
  def average_rate
    return Neta.average_rate(self.netas)
  end
  
  def free_netas
    return self.netas.includes(:reviews).where(price: 0)
  end
  
  # def profile_gauge
  #   done = 0
  #   total = 0
  #   if self.nickname.present?
  #     done +=1
  #   end
  #   total += 1
  #   if self.image.attachment.present?
  #     done += 1
  #   end
  #   total += 1
  #   if self.birthdate.present?
  #     done += 1
  #   end
  #   total += 1
  #   if self.gender.present?
  #     done += 1
  #   end
  #   total += 1
  #   if self.prefecture_code.present?
  #     done += 1
  #   end
  #   total += 1
  #   if self.introduction.present?
  #     done += 1
  #   end
  #   total += 1
    
  #   val = (100*done/total)
  #   return val.round(0)
  # end
  
  def premium_user
    netas = self.free_netas
    free_neta_count = netas.count
    avg = Neta.average_rate(netas)
    if free_neta_count >= 3 && avg >= 3
      return [true, avg, free_neta_count]
    else
      return [false, avg, free_neta_count]
    end
  end
  
  def premium_qualified
    if self.premium_user[0] && self.account.present?
      if self.account.stripe_status == "verified"
        return true
      else
        return false
      end
    else
      return false
    end
  end
  
  def self.bought_netas(bought_trades)
    b_netaids = []
    bought_trades.each do |trade|
      if trade.tradeable_type == "Neta"
        b_netaids << trade.tradeable_id
      end
    end
    return Neta.includes({user: [image_attachment: :blob]}, :hashtags).where(id: b_netaids)
  end
  
  def bookmarked_netas
    i_netaids = []
    self.bookmarks.each do |bookmark|
      if bookmark.bookmarkable_type == "Neta"
        i_netaids << bookmark.bookmarkable_id
      end
    end
    return Neta.includes({user: [image_attachment: :blob]}, :hashtags).where(id: i_netaids).order("created_at DESC")
  end
  
  def bookmarked_topics
    i_topicids = []
    self.bookmarks.each do |bookmark|
      if bookmark.bookmarkable_type == "Topic"
        i_topicids << bookmark.bookmarkable_id
      end
    end
    return Topic.includes([header_image_attachment: :blob], {user: [image_attachment: :blob]}, :netas).where(id: i_topicids).order("created_at DESC")
  end
  
  def get_customer
    if self.stripe_cus_id.present?
      begin
        customer = JSON.parse(Stripe::Customer.retrieve(self.stripe_cus_id).to_s)
      rescue => e
        return [false, "Stripe error - #{e.message}"]
      end
      if customer["id"].present?
        return [true, customer]
      else
        return [false, "customer data does not exist"]
      end
    else
      return [false, "stripe_cus_id is blank"]
    end
  end
  
  def get_cards
    if self.stripe_cus_id.present?
      begin
        cards = JSON.parse(Stripe::Customer.list_sources(self.stripe_cus_id,{limit: 3, object: 'card',}).to_s)
      rescue => e
        return [false, "Stripe error - #{e.message}"]
      end
      if cards["data"].present?
        return [true, cards]
      else
        return [false, "cards list does not exist"]
      end
    else
      return [false, "stripe_cus_id is blank"]
    end
  end
  
  def get_card_details(card_id)
    if self.stripe_cus_id.present?
      if card_id.present?
        begin
          customer = Stripe::Customer.retrieve(self.stripe_cus_id)
          card = JSON.parse(customer.sources.retrieve(card_id).to_s)
        rescue => e
          return [false, "Stripe error - #{e.message}"]
        end
        if card["object"] == "card"
          if card["customer"] == self.stripe_cus_id
            return [true, card]
          else
            return [false, "customer_id on card is #{card["customer"]} does not match user.stripe_cus_id #{self.stripe_cus_id}"]
          end
        else
          return [false, "card data does not exist"]
        end
      else
        return [false, "card_id is blank"]
      end
    else
      return [false, "stripe_cus_id is blank"]
    end
  end

  def add_card(token)
    if self.stripe_cus_id.present?
      if token.present?
        begin
          card = JSON.parse(Stripe::Customer.create_source(self.stripe_cus_id,{source: token,}).to_s)
        rescue => e
          return [false, "Stripe error - #{e.message}"]
        end
      else
        return [false, "token is blank"]
      end
    else
      return [false, "stripe_cus_id is blank"]
    end
    
    chg_default_card_res = self.change_default_card(card["id"])
    if chg_default_card_res[0]
       return [true, card]
    else
      return [false, "error updating default card : #{chg_default_card_res[1]}"]
    end
  end
  
  def change_default_card(card_id)
    if card_id.present?
      cards = self.get_cards
      if cards[0]
        card_exists = false
        cards[1]["data"].each do |card_obj|
          if card_obj["id"] == card_id
            card_exists = true
          end
        end
        unless card_exists
          return [false, "card does not exist with this user"]
        end
      else
        return [false, "failed to get cards : #{cards[1]}"]
      end
      
      begin
        customer = JSON.parse(Stripe::Customer.update(self.stripe_cus_id,{default_source: card_id,}).to_s)
      rescue => e
        return [false, "Stripe error - #{e.message}"]
      end

      if customer["id"].present?
        return [true, customer]
      else
        return [false, "customer not present in results"]
      end
    else
      return [false, "card_id is blank"]
    end
  end
  
  def create_cus_from_card(token)
    if token.present?
      begin
        customer = JSON.parse(Stripe::Customer.create({name: self.nickname, source: token, email: self.email}).to_s)
      rescue => e
        return [false, "Stripe error - #{e.message}"]
      end
      if customer["id"].present?
        self.update!(stripe_cus_id: customer["id"])
        return [true, customer]
      else
        return [false, "customer not present in results"]
      end
    else
      return [false, "token is blank"]
    end
  end
  
  def get_balance
    if self.account.present?
      res = self.account.get_stripe_balance
      if res[0]
        if res[1]["available"][0]["amount"].present?
          return [true, res[1]["available"][0]["amount"]]
        else
          return [false, "failed to retrieve user's available balance"]
        end
      else
        return [false, "failed to retrieve user's balance info : #{res[1]}"]
      end
    else
      return [false, "user's account does not exist"]
    end
  end
  
  def set_source(charge_params)
    
    if charge_params[:stripeToken].present? #新規カードを使用
      if self.stripe_cus_id.present?
        card_res = self.add_card(charge_params[:stripeToken]) #新規カードを追加し、Cardを返す
        if card_res[0]
          return [true, card_res[1]]
        else
          return [false, "failed to add card : #{card_res[1]}"]
        end
      else
        customer_res = self.create_cus_from_card(charge_params[:stripeToken]) #新規Customerを作成、カードをセットしCustomerを返す
        if customer_res[0]
          return [true, customer_res[1]]
        else
          return [false, "failed to set card to customer : #{customer_res[1]}"]
        end
      end
    
    elsif charge_params[:card_id].present? #既存カードを使用
      if self.stripe_cus_id.present?
        customer_res = self.change_default_card(charge_params[:card_id]) #既存カードをセットしCustomerを返す
        if customer_res[0]
          return [true, customer_res[1]]
        else
          return [false, "failed to change card : #{customer_res[1]}"]
        end
      else
        return [false, "stripe_cus_id is blank"]
      end
      
    elsif charge_params[:user_points].present? #ポイントを使用
      if self.account.present?
        if charge_params[:charge_amount].present?
          user_points = charge_params[:user_points].to_i
          charge_amount = charge_params[:charge_amount].to_i
          if user_points >= charge_amount
            account_res = self.account.get_stripe_account
            if account_res[0]
              return [true, account_res[1]] #Account infoを返す
            else
              return [false, "failed to get stripe account : #{account_res[1]}"]
            end
          else
            return [false, "insufficient points"]
          end
        else
          return [false, "charge amount does not exist"]
        end
      else
        return [false, "user account does not exist"]
      end
    
    else
      return [false, "no valid source exists"]
    end
  end
  
  def get_sold_netas_info

    trades = Trade.where(seller_id: self.id, tradeable_type: "Neta").order("created_at DESC") 
    
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
        buyers_hash.merge!({buyer.id => {"nickname" => buyer.nickname}})
      end
      neta_hash = {}
      netas.each do |neta|
        neta_hash.merge!({neta.id => {"text" => neta.text.truncate(10)}})
      end
      review_hash = {}
      reviews.each do |review|
        review_hash.merge!({"neta_"+review.neta_id.to_s+"_user_"+review.user_id.to_s => { "rate" => review.rate }})
      end
      
      sold_netas_info = []
      trades.each do |trade|
        if review_hash.has_key?("neta_"+trade.tradeable_id.to_s+"_user_"+trade.buyer_id.to_s)
          rate = review_hash["neta_"+trade.tradeable_id.to_s+"_user_"+trade.buyer_id.to_s]["rate"]
        else
          rate = nil
        end
        sold_netas_info << {
                              "traded_at" => trade.created_at, 
                              "text" => neta_hash[trade.tradeable_id]["text"],
                              "price" => trade.price,
                              "buyer_id" => trade.buyer_id,
                              "buyer_nickname" => buyers_hash[trade.buyer_id]["nickname"],
                              "review_rate" => rate
                            }
      end
      return [true, sold_netas_info]
    else
      return [false, "No sold netas found for user_id #{self.id}"]
    end
  end
  
  private
  
  # Custom Validations
  
  def image_content_type
    extension = ['image/png', 'image/jpg', 'image/jpeg']
    errors.add(:image, "の拡張子はサポートされていません。") unless image.content_type.in?(extension)
  end

  def was_attached?
    self.image.attached?
  end
  
  def gender_code_check
    if self.gender.present?
      if self.gender < 0 || self.gender > 3
        errors.add(:gender, "Invalid gender code")
      end
    end
  end
  
  def prefecture_code_check
    if self.prefecture_code.present?
      if self.prefecture_code < 1 || self.prefecture_code > 47
        errors.add(:prefecture_code, "Invalid prefecture code")
      end
    end
  end

  def age_check
    if self.birthdate.present?
      if self.birthdate > Time.zone.today.prev_year(13)
        errors.add(:birthdate, "：１３歳未満はご利用できません。")
      end
    end
  end
  
  def stripe_cus_id_check
    if self.stripe_cus_id.present?
      unless self.stripe_cus_id.starts_with? 'cus_'
        errors.add(:stripe_cus_id, "invalid stripe_cus_id")
      end
    end
  end

end
