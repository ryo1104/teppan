FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "tester#{n}@example.com" }
    sequence(:nickname) { |n| "ryohei#{n}" }
    password { "00000000" }
    password_confirmation { "00000000" }
    confirmed_at { Time.zone.yesterday }
    gender { "1" }
    prefecture_code { "1" }
    birthdate { Time.zone.today.prev_year(19) }
    introduction { Faker::Lorem.characters(number: 800) }
    stripe_cus_id { "cus_"+Faker::Lorem.characters(number: 14) }
    follows_count { "0" }
  end
  
end
