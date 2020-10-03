class StripeIdcard < ApplicationRecord
  include StripeUtils
  belongs_to        :stripe_account
  has_one_attached  :image
  validates :stripe_account_id, presence: true, uniqueness: { scope: :frontback, message: 'IDスキャン登録は表・裏につき1枚ずつです。' }
  validate  :check_image

  def verification_docs
    {
      individual: {
        verification: {
          document: {
            "#{frontback}": stripe_file_id.to_s
          }
        }
      }
    }
  end

  private

  # Custom Validations
  def check_image
    if image.attached?
      errors.add(:image, 'の添付可能なファイルサイズは5MB以内です。') if image.blob.byte_size > 5.megabyte
      content_type = %w[image/png image/jpg image/jpeg]
      errors.add(:image, 'のファイル形式はJPGまたはPNGのみ登録可能です。') unless image.blob.content_type.in?(content_type)
    else
      errors.add(:image, 'が選択されていません。')
    end
  end
end
