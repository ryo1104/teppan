FactoryBot.define do
  factory :follow do
    sequence(:follower_id) { |n| n }
    trait :with_user do
      user
    end
  end
end
