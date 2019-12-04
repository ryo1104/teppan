FactoryBot.define do
  factory :review do
    text { Faker::Lorem.characters(number: 200)}
    rate { Faker::Number.within(range: 1..5) }
    trait :with_user do
      association :user, factory: :user
    end
    association :neta, factory: :neta
  end
end
