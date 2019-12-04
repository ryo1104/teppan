class Bank < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  has_many :branches, dependent: :destroy
end
