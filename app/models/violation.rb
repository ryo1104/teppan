class Violation < ApplicationRecord
  belongs_to  :user
  validates   :user_id, uniqueness: {:scope => :reporter_id, message: "この通報はすでに存在します。" }
  validates   :reporter_id, presence: true, numericality: { only_integer: true }
  validates   :block, inclusion: { in: [1, 0] }
  validates   :text, length: { maximum: 400 }
end
