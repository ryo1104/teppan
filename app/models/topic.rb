class Topic < ApplicationRecord
  belongs_to  :user
  has_many    :netas
  has_many    :pageviews, as: :pageviewable
  has_many    :interests, as: :interestable
  has_many    :comments,  as: :commentable, dependent: :destroy
  has_many    :likes,     as: :likeable, dependent: :destroy
  validates   :title,     presence: true, uniqueness: { case_sensitive: true }, length: { maximum: 30 }
  validates   :text,      presence: true, length: { maximum: 200 }
  
  def max_rate
    maxrate = 0
    self.netas.each do |neta|
      rate = neta.average_rate
      if rate != 0 && rate > maxrate
          maxrate = rate
      end
    end
    return maxrate
  end
  
  def owner(user)
    if self.user_id == user.id
      return true
    else 
      return false
    end
  end
  
  def editable(user)
    editable = true
    unless owner(user)
      editable = false
    else
      self.netas.each do |neta|
        if neta.user_id != user.id
          editable = false
        end
      end
    end
    return editable
  end
  
  def potential_interest(user_id)
    interest = self.interests.find_by(user_id: user_id)
    if interest.present?
      return false
    else
      return true
    end
  end
  
  def add_pageview(user)
    from = Time.zone.now - 1.day
    to = Time.zone.now
    self.pageviews.find_or_create_by(user_id: user.id, created_at: from..to)
  end
  
  def is_deleteable
    if self.netas.present?
      return false
    else
      return true
    end
  end
  
end
