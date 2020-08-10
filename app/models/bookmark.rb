class Bookmark < ApplicationRecord
  belongs_to  :user
  belongs_to  :bookmarkable, polymorphic: true
  counter_culture :bookmarkable
  validates :user_id, uniqueness: {:scope => [:bookmarkable_type, :bookmarkable_id], message: "このブックマークはすでに存在します。" }
end
