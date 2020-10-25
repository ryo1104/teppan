class StripeIdcard < ApplicationRecord
  include StripeUtils
  belongs_to        :stripe_account
  has_one_attached  :image
  validates :stripe_account_id, presence: true, uniqueness: { scope: :frontback, message: 'につき表面・裏面のスキャンを1つずつご登録下さい。' }
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

  def create_stripe_file(file, name)
    File.open("tmp/#{name}", 'wb') { |f| f.write(file.read) }
    file_upload_hash = JSON.parse(Stripe::File.create({ purpose: 'identity_document', file: File.open("tmp/#{name}", 'r') }).to_s)
    File.delete("tmp/#{name}")
    file_upload_hash
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
