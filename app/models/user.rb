class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :email, presence: true, uniqueness: true
  validate  :gender_code_check
  validate  :prefecture_code_check
  validate  :age_check
  validates :introduction, length: { maximum: 800 }
  validate  :stripe_cus_id_check
  validates :follows_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
