class Bookmark < ApplicationRecord
  belongs_to  :user
  belongs_to  :bookmarkable, polymorphic: true
  counter_culture :bookmarkable
  validates :user_id, uniqueness: { scope: %i[bookmarkable_type bookmarkable_id], message: "この#{Bookmark.model_name.human}はすでに存在します。" }
end
