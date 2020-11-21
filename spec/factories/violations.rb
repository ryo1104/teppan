FactoryBot.define do
  factory :violation do
    sequence(:reporter_id) { |n| n }
    block { false }
    text { Faker::Lorem.characters(number: 400) }
    trait :with_user do
      user
    end
  end
end
