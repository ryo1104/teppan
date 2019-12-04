class Comment < ApplicationRecord
  belongs_to  :user
  belongs_to  :commentable, polymorphic: true
  counter_culture :commentable
  has_many    :likes, as: :likeable, dependent: :destroy
  validates   :text, presence: true, length: { in: 2..100 }
  validates   :likes_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0}
  
  # def parent_path
  #   if self.commentable_type == "Review"
  #     review = Review.find(self.commentable_id)
  #     parent_type = "netas"
  #     parent_id = review.neta_id
  #   else
  #     parent_type = self.commentable_type.pluralize.downcase
  #     parent_id = self.commentable_id
  #   end
  #   path = Hash.new()
  #   path[:type] = parent_type
  #   path[:id]   = parent_id
  #   return path
  # end
end
