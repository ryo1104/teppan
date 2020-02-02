class HashtagHit < ApplicationRecord
  belongs_to  :hashtag
  belongs_to  :user
end
