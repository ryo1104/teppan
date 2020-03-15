class Idcard < ApplicationRecord
  include StripeUtils
  belongs_to        :account
  has_one_attached  :image
  validates :account_id, presence: true, uniqueness: { scope: :frontback, message: "IDスキャン登録は表・裏につき1枚ずつです。" }
  validate  :check_image

  def verification_docs
    return {
              individual:{
                verification:{
                  document:{
                    "#{self.frontback}":"#{self.stripe_file_id}"
                  },
                },
              },
            }
  end


  private
  
  # Custom Validations
  def check_image
    if image.attached?
      if image.blob.byte_size > 5.megabyte
        errors.add(:image, "の添付可能なファイルサイズは5MB以内です。")
      end
      content_type = %w[image/png image/jpg image/jpeg]
      unless image.blob.content_type.in?(content_type)
        errors.add(:image, "のファイル形式はJPGまたはPNGのみ登録可能です。")
      end
    else
      errors.add(:image, "が選択されていません。")
    end
  end
  

end
