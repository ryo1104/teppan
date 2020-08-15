class Topic < ApplicationRecord
  belongs_to :user
  has_one_attached :header_image
  has_rich_text :content
  has_many      :netas, dependent: :restrict_with_error
  has_many      :pageviews, as: :pageviewable, dependent: :destroy
  has_many      :bookmarks, as: :bookmarkable, dependent: :destroy
  has_many      :comments,  as: :commentable, dependent: :destroy
  has_many      :likes,     as: :likeable, dependent: :destroy
  validates     :title,     presence: true, uniqueness: { case_sensitive: true }, length: { maximum: 35 }
  validate      :content_check
  validate      :header_image_type, if: :was_attached?

  def header_image_type
    extension = ['image/png', 'image/jpg', 'image/jpeg', 'image/gif']
    errors.add(:header_image, 'の拡張子はサポートされていません。') unless header_image.content_type.in?(extension)
  end

  def was_attached?
    header_image.attached?
  end

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

  private

  def content_check
    errors.add(:content, ' cannot be blank') unless content.body.present?
    # Need attachment checks. Below does not work because at this point blob is not attached..
    # self.content.embeds.blobs.each do |blob|
    #   if blob.byte_size.to_i > 10.megabytes
    #     errors.add(:content, " size must be smaller than 10MB")
    #   end
    # end
  end
end
