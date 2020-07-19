class Review < ApplicationRecord
  belongs_to  :neta
  counter_culture :neta
  belongs_to  :user
  validates   :user_id, uniqueness: {:scope => :neta_id, message: "このネタへのレビューは存在します。" }
  validates   :rate, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates   :text, length: { maximum: 200 }
end
