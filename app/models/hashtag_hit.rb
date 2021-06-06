# frozen_string_literal: true

class HashtagHit < ApplicationRecord
  belongs_to  :hashtag
  belongs_to  :user
end
