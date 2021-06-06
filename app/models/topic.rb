# frozen_string_literal: true

class Topic < ApplicationRecord
  belongs_to :user
  has_rich_text :content
  has_many      :netas, dependent: :restrict_with_error
  has_many      :pageviews, as: :pageviewable, dependent: :destroy
  has_many      :bookmarks, as: :bookmarkable, dependent: :destroy
  has_many      :comments,  as: :commentable, dependent: :destroy
  has_many      :likes,     as: :likeable, dependent: :destroy
  validates     :title,     presence: true, uniqueness: { case_sensitive: true }, length: { maximum: 35 }
  validate      :content_exists
  validate      :header_url_check

  def max_rate
    maxrate = 0
    netas.each do |neta|
      rate = neta.average_rate
      maxrate = rate if rate != 0 && rate > maxrate
    end
    maxrate
  end

  def owner(user)
    user_id == user.id
  end

  def editable(user)
    editable = true
    if owner(user)
      netas.each do |neta|
        editable = false if neta.user_id != user.id
      end
    else
      editable = false
    end
    editable
  end

  def bookmarked(user_id)
    bookmark = bookmarks.find_by(user_id: user_id)
    if bookmark.present?
      true
    else
      false
    end
  end

  def add_pageview(user)
    from = Time.zone.now - 1.day
    to = Time.zone.now
    pageviews.find_or_create_by(user_id: user.id, created_at: from..to)
  end

  def deleteable
    if netas.present?
      false
    else
      true
    end
  end

  def purge_s3_object
    if header_url_check
      object = S3_BUCKET.object(header_img_url.split('amazonaws.com/')[1])
      if object.present?
        object.delete
        true
      else
        false
      end
    else
      if errors.present?
        false
      else
        true
      end
    end
  end

  private

  def content_exists
    errors.add(:content, I18n.t('errors.messages.blank')) if content.body.blank?
    # Need attachment checks. Below does not work because at this point blob is not attached.
    # self.content.embeds.blobs.each do |blob|
    #   if blob.byte_size.to_i > 5.megabytes
    #     errors.add(:content, " size must be smaller than 5MB")
    #   end
    # end
  end

  def header_url_check
    if header_img_url.present?
      if header_img_url.include?('amazonaws.com/')
        path = header_img_url.split('amazonaws.com/')[1]
        if path.include?('topic_header_images')
          true
        else
          errors.add(:header_img_url, I18n.t('errors.messages.invalid'))
          false
        end
      else
        errors.add(:header_img_url, I18n.t('errors.messages.invalid'))
        false
      end
    else
      false
    end
  end
end
