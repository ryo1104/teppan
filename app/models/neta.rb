class Neta < ApplicationRecord
  belongs_to  :user
  belongs_to  :topic
  counter_culture :topic
  has_many    :reviews
  has_many    :trades, as: :tradeable
  has_many    :pageviews, as: :pageviewable
  has_many    :interests, as: :interestable
  has_many    :rankings, as: :rankable
  has_many    :hashtag_netas
  has_many    :hashtags, through: :hashtag_netas
  validates   :text,      presence: true, length: { in: 20..800 }
  validates   :valuetext, length: { maximum: 800 }
  validates   :price,     presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10000 }
  validates   :private_flag, inclusion: { in: [true, false] }
  
  def self.average_rate(netas)
    gross_count = 0
    gross_rate = 0
    netas.each do |neta|
      if neta.reviews_count != 0
        gross_rate += neta.average_rate * neta.reviews_count
        gross_count += neta.reviews_count
      end
    end
    if count != 0
      return (gross_rate/gross_count.to_f).round(2)
    else
      return "-"
    end
  end

  def update_average_rate
    if self.reviews.present?
      avg = self.reviews.average(:rate).round(2)
      if avg.is_a? Numeric
        if self.update!(average_rate: avg)
          return [true, avg]
        else
          return [false, "error updating average_rate"]
        end
      else
        return [false, "error retrieving average rate"]
      end
    else
      return [false, "no reviews exist for the neta"]
    end
  end
  
  def owner(user)
    if self.user_id == user.id
      return true 
    else 
      return false
    end
  end
  
  def editable
    if self.trades.count == 0
      return true
    else 
      return false
    end
  end
  
  def for_sale
    if self.user.premium_user[0]
      if self.user.account.present?
        if self.user.account.stripe_status == "verified"
          return true
        else
          return false
        end
      else
        return false
      end
    else
      return false
    end
  end
  
  def public_str
    if self.private_flag
      return "非公開"
    else
      return "公開"
    end
  end
  
  def add_pageview(user)
    from = Time.zone.now - 1.day
    to = Time.zone.now
    self.pageviews.find_or_create_by(user_id: user.id, created_at: from..to)
  end
  
  def has_dependents
    if self.reviews.present?
      return true
    elsif self.trades.present?
      return true
    elsif self.pageviews.present?
      return true
    elsif self.interests.present?
      return true
    elsif self.rankings.present?
      return true
    else
      return false
    end
  end

  after_create do
    neta = Neta.find_by(id: self.id)
    hashtags  = self.text.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    hashtags.uniq.map do |hashtag|
      tag = Hashtag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
      tag.add_netacount
      tag.add_hit(neta.user)
      neta.hashtags << tag
    end
  end
  
  before_update do
    neta = Neta.find_by(id: self.id)
    neta.hashtags.clear
    hashtags  = self.text.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
    hashtags.uniq.map do |hashtag|
      tag = Hashtag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
      neta.hashtags << tag
    end
  end
end
