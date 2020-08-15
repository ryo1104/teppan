FactoryBot.define do
  factory :comment do
    text { Faker::Lorem.characters(number: 100) }
    likes_count { '0' }
    trait :with_user do
      association :user, factory: :user
    end
  end
end
