class Idcard < ApplicationRecord
  belongs_to        :account
  has_one_attached  :image
  validates :account_id, presence: true, uniqueness: { scope: :frontback, message: "IDスキャン登録は表・裏につき1枚ずつです。" }
  include StripeUtils
end
