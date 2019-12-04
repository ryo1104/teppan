class Branch < ApplicationRecord
  validates :bank_id, presence: true, uniqueness: { scope: :code }
  belongs_to :bank
end
