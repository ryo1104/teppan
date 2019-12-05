class Bank < ApplicationRecord
  validates :code, presence: true, uniqueness: { case_sensitive: true }
  has_many :branches, dependent: :destroy
end
