class Neta < ApplicationRecord
  belongs_to  :user
  belongs_to  :topic
  counter_culture :topic
  has_rich_text :content
  has_rich_text :valuecontent
  has_many :reviews
  has_many :trades, as: :tradeable
  has_many :pageviews, as: :pageviewable
  has_many :bookmarks, as: :bookmarkable
  has_many :rankings, as: :rankable
  has_many :hashtag_netas
  has_many :hashtags, through: :hashtag_netas
  validates :title, presence: true, length: { in: 5..35 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10_000 }
  validates :private_flag, inclusion: { in: [true, false] }
  validate  :content_check
  validate  :valuecontent_check

  def self.average_rate(netas)
    gross_count = 0
    gross_rate = 0
    if netas.present?
      netas.each do |neta|
        if neta.reviews_count != 0
          gross_rate += neta.average_rate * neta.reviews_count
          gross_count += neta.reviews_count
        end
      end
      if gross_count != 0
        (gross_rate / gross_count.to_f).round(2)
      else
        0
      end
    else
      0
    end
  end

  def update_average_rate
    if reviews.present?
      avg = reviews.average(:rate).round(2)
      if avg.is_a? Numeric
        if update!(average_rate: avg)
          [true, avg]
        else
          [false, 'error updating average_rate']
        end
      else
        [false, 'error retrieving average rate']
      end
    else
      [false, 'no reviews exist for the neta']
    end
  end

  def owner(user)
    user_id == user.id
  end

  def editable
    trades.count == 0
  end

  def is_free
    price == 0
  end

  def for_sale
    if price != 0
      if user.premium_user[0]
        if user.stripe_account.present?
          user.stripe_account.status == 'verified'
        else
          false
        end
      else
        false
      end
    else
      false
    end
  end

  def public_str
    if private_flag
      '非公開'
    else
      '公開'
    end
  end

  def add_pageview(user)
    from = Time.zone.now - 1.day
    to = Time.zone.now
    pageviews.find_or_create_by(user_id: user.id, created_at: from..to)
  end

  def has_dependents
    if reviews.present?
      true
    elsif trades.present?
      true
    elsif pageviews.present?
      true
    elsif bookmarks.present?
      true
    elsif rankings.present?
      true
    else
      false
    end
  end

  def bookmarked(user_id)
    bookmark = bookmarks.find_by(user_id: user_id)
    if bookmark.present?
      true
    else
      false
    end
  end

  def check_hashtags(tag_array)
    if tag_array.present?
      if tag_array.size > 10
        errors.add(:hashtags, I18n.t('errors.messages.attach_too_many', attach_limit: '10'))
        false
      else
        true
      end
    else
      true
    end
  end

  def add_hashtags(tag_array)
    if tag_array.present?
      if delete_hashtags
        tag_array.uniq.map do |tag_name|
          hashtag = Hashtag.find_or_create_by(hashname: tag_name)
          hashtag.update_hiragana
          hashtags << hashtag
          hashtag.update_netacount
        end
        true
      else
        false
      end
    else
      false
    end
  end

  def delete_hashtags
    hashtags.clear if hashtags.present?
  end

  def get_hashtags_str
    if hashtags.present?
      tags = hashtags
      tag_array = []
      tags.each do |tag|
        tag_array.push(tag.hashname)
      end
      tag_array.join(',')
    else
      ''
    end
  end

  def self.details_from_ids(ids)
    netas = Neta.where(id: ids)
    if netas.present?
      neta_hash = {}
      netas.each do |neta|
        neta_hash.merge!({ neta.id => { 'title' => neta.title } })
      end
      neta_hash
    else
      false
    end
  end

  private

  def content_check
    errors.add(:content, 'を入力してください。') unless content.body.present?
    # Need attachment checks. Below does not work because at this point blob is not attached..
    # self.content.embeds.blobs.each do |blob|
    #   if blob.byte_size.to_i > 10.megabytes
    #     errors.add(:content, " size must be smaller than 10MB")
    #   end
    # end
  end

  def valuecontent_check
    if price != 0
      errors.add(:valuecontent, 'を入力してください。') unless valuecontent.body.present?
      # Need attachment checks. Below does not work because at this point blob is not attached..
      # self.valuecontent.embeds.blobs.each do |blob|
      #   if blob.byte_size.to_i > 10.megabytes
      #     errors.add(:valuecontent, " size must be smaller than 10MB")
      #   end
      # end
    end
  end
end
