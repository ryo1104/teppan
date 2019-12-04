class Like < ApplicationRecord
  belongs_to  :user
  belongs_to  :likeable, polymorphic: true
  counter_culture :likeable
  validates :user_id, uniqueness: {:scope => [:likeable_type, :likeable_id], message: "このいいねはすでに存在します。" }
  
  # def parent_path
  #   if self.likeable_type == "comment"
  #     comment = comment.find(self.likeable_id)
  #     parent_type = comment.commentable_type.pluralize.downcase
  #     parent_id = comment.commentable_id
  #   else
  #     if self.likeable_type == "Review"
  #       review = Review.find(self.likeable_id)
  #       parent_type = "netas"
  #       parent_id = review.neta_id
  #     else
  #       parent_type = self.likeable_type.pluralize.downcase
  #       parent_id = self.likeable_id
  #     end
  #   end
  #   path = Hash.new()
  #   path[:type] = parent_type
  #   path[:id]   = parent_id
  #   return path
  # end
end
