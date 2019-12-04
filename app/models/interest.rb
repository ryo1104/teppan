class Interest < ApplicationRecord
  belongs_to  :user
  belongs_to  :interestable, polymorphic: true
  counter_culture :interestable
  validates :user_id, uniqueness: {:scope => [:interestable_type, :interestable_id], message: "このブックマークはすでに存在します。" }
end
