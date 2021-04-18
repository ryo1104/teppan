FactoryBot.define do
  factory :inquiry do
    email   { Faker::Internet.email }
    message { Faker::Lorem.characters(number: 400) }
  end
end
