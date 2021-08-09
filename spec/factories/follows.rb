FactoryBot.define do
  factory :follow do
    sequence(:follower_id) { |n| n }
    sequence(:followed_id) { |n| n }
  end
end
