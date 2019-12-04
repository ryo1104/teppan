class Review < ApplicationRecord
  belongs_to  :neta
  counter_culture :neta
  belongs_to  :user
  has_many    :likes, as: :likeable
  has_many    :comments, as: :commentable
  validates   :user_id, uniqueness: {:scope => :neta_id, message: "このネタへのレビューは存在します。" }
  validates   :rate, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates   :text, length: { maximum: 200 }
  validates   :likes_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0}
end
