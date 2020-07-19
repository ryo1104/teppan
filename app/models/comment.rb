class Comment < ApplicationRecord
  belongs_to  :user
  belongs_to  :commentable, polymorphic: true
  counter_culture :commentable
  has_many    :likes, as: :likeable, dependent: :destroy
  validates   :text, presence: true, length: { in: 2..200 }
  validates   :likes_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0}
  validates   :is_deleted, inclusion: { in: [true, false] }
end
