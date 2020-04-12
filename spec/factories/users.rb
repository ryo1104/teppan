FactoryBot.define do
  factory :user do
    # password = Faker::Internet.password(min_length: 8)
    # sequence(:email) { |n| "tester#{n}@example.com" }
    email { Faker::Internet.email }
    sequence(:nickname) { |n| "ryohei#{n}" }
    password { "aaoinawei897d" }
    password_confirmation { "aaoinawei897d" }
    confirmed_at { Time.zone.yesterday }
    gender { "1" }
    prefecture_code { "1" }
    birthdate { Time.zone.today.prev_year(19) }
    introduction { Faker::Lorem.characters(number: 800) }
    stripe_cus_id { "cus_"+Faker::Lorem.characters(number: 14) }
    follows_count { "0" }
  end
  
end
