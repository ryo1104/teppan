class Follow < ApplicationRecord
  belongs_to :user
  counter_culture :user
  validates   :user_id, uniqueness: { scope: :follower_id, message: "この#{Follow.model_name.human}はすでに存在します。" }
  validates   :follower_id, presence: true, numericality: { only_integer: true }
end
