FactoryBot.define do
  factory :topic do
    sequence(:title) { |n| "Topic #{n}" }
    text { Faker::Lorem.characters(number: 200) }
    trait :with_user do
      association :user, factory: :user
    end
  end
end
