# frozen_string_literal: true

class Follow < ApplicationRecord
  belongs_to :followed, class_name: 'User'
  belongs_to :follower, class_name: 'User'
  counter_culture :followed, column_name: 'followers_count'
  counter_culture :follower, column_name: 'followings_count'
  validates :follower_id, numericality: { only_integer: true }
  validates :followed_id, numericality: { only_integer: true },
                          uniqueness: { scope: :follower_id, message: "この#{Follow.model_name.human}はすでに登録されています。" }
end
