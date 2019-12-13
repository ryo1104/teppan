FactoryBot.define do
  factory :topic do
    sequence(:title) { |n| "Topic #{n}" }
    content { Faker::Lorem.characters(number: 100) }
    trait :with_user do
      association :user, factory: :user
    end
  end
end
