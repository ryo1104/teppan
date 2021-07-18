# frozen_string_literal: true

class User < ApplicationRecord
  include StripeUtils

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable,
         :trackable, :omniauthable, omniauth_providers: %i[google_oauth2 twitter yahoojp]

  has_many  :topics, -> { order('netas_count DESC') }, dependent: :destroy, inverse_of: :user
  has_many  :netas, -> { order('average_rate DESC') }, dependent: :destroy, inverse_of: :user
  has_many  :pageviews,  -> { order('created_at DESC') }, dependent: :destroy, inverse_of: :user
  has_many  :bookmarks,  -> { order('created_at DESC') }, dependent: :destroy, inverse_of: :user
  has_many  :hashtag_hits, -> { order('created_at DESC') }, dependent: :destroy, inverse_of: :user
  has_many  :comments, dependent: :destroy
  has_many  :follows, dependent: :destroy
  has_many  :reviews, dependent: :destroy
  has_many  :violations, dependent: :destroy
  has_one   :stripe_account, dependent: :destroy
  has_rich_text :introduction
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validate  :gender_code_check
  validate  :age_check
  validate  :stripe_cus_id_check
  validates :follows_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :unregistered, inclusion: { in: [true, false] }

  def self.find_or_create_for_oauth(auth)
    auth_check = auth_check(auth)
    return [false, auth_check[1]] unless auth_check[0]

    email = if auth.provider == 'twitter'
              "#{auth.info.name}@twitter-hoge.com" # twitter APIでPrivacyPolicy等の設定をすればauth.info.emailから取得可能になる
            else
              auth.info.email
            end

    gender = case auth.info.gender
             when 'male'
               1
             when 'female'
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

  def age
    if birthdate.present?
      date_format = '%Y%m%d'
      # Rubyは整数同士の除算は小数部は切り捨てられるため、floorは不要
      age = (Time.zone.today.strftime(date_format).to_i - birthdate.strftime(date_format).to_i) / 10_000

      age if age.positive?
    else
      ' - '
    end
  end

  def gender_str
    if gender.present?
      case gender
      when 1
        '男性'
      when 2
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
    User.includes(:netas).where(id: following_user_ids.uniq)
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
    User.includes(:netas).where(id: followed_user_ids.uniq)
  end

  def followed_by(user_id)
    follow = Follow.find_by(user_id: id, follower_id: user_id)
    if follow.present?
      true
    else
      false
    end
  end

  def blocked_by(user_id)
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
    Neta.includes(:user, :hashtags).where(id: b_netaids)
  end

  def bookmarked_netas
    i_netaids = []
    bookmarks.each do |bookmark|
      i_netaids << bookmark.bookmarkable_id if bookmark.bookmarkable_type == 'Neta'
    end
    Neta.includes(:user, :hashtags).where(id: i_netaids).order('created_at DESC')
  end

  def bookmarked_topics
    i_topicids = []
    bookmarks.each do |bookmark|
      i_topicids << bookmark.bookmarkable_id if bookmark.bookmarkable_type == 'Topic'
    end
    Topic.includes(:user, :netas).where(id: i_topicids).order('created_at DESC')
  end

  # def get_customer
  #   if stripe_cus_id.present?
  #     begin
  #       customer = JSON.parse(Stripe::Customer.retrieve(stripe_cus_id).to_s)
  #     rescue StandardError => e
  #       return [false, "Stripe error - #{e.message}"]
  #     end
  #     if customer['id'].present?
  #       [true, customer]
  #     else
  #       [false, 'customer data does not exist']
  #     end
  #   else
  #     [false, 'stripe_cus_id is blank']
  #   end
  # end

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

  def can_unregister
    if get_balance[0]
      [false, 'User cash balance remaining']
    else
      [true, '']
    end
  end

  def purge_s3_object
    if avatar_url_check
      object = S3_BUCKET.object(avatar_img_url.split('amazonaws.com/')[1])
      if object.present?
        object.delete
        true
      else
        false
      end
    elsif errors.present?
      false
    else
      true
    end
  end

  def self.auth_check(auth)
    return [false, 'auth is empty'] if auth.blank?

    providers = %w[yahoojp twitter google_oauth2]
    return [false, 'unknown provider'] unless providers.include?(auth['provider'])

    [true, nil]
  end

  private_class_method :auth_check

  private

  def gender_code_check
    errors.add(:gender, I18n.t('errors.messages.invalid')) if gender.present? && (gender < 1 || gender > 3)
  end

  def age_check
    if birthdate.present? && (birthdate > Time.zone.today.prev_year(13))
      errors.add(:birthdate,
                 I18n.t('errors.messages.underage', age_limit: '13'))
    end
  end

  def stripe_cus_id_check
    errors.add(:stripe_cus_id, I18n.t('errors.messages.invalid')) if stripe_cus_id.present? && !(stripe_cus_id.starts_with? 'cus_')
  end

  def avatar_url_check
    if avatar_img_url.present?
      if avatar_img_url.include?('amazonaws.com/')
        path = avatar_img_url.split('amazonaws.com/')[1]
        if path.include?('user_avatar_images')
          true
        else
          errors.add(:avatar_img_url, I18n.t('errors.messages.invalid'))
          false
        end
      else
        errors.add(:avatar_img_url, I18n.t('errors.messages.invalid'))
        false
      end
    else
      false
    end
  end
end
