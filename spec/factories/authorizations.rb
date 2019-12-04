FactoryBot.define do
  factory :authorization do
    trait :with_user do
      association :user, factory: :user
    end
    provider { "yahoojp" }
    uid { Faker::Lorem.characters(number: 20) }
  end
end
