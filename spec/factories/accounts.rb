FactoryBot.define do
  factory :account do
    association :user, factory: :user
    stripe_acct_id  { "acct_"+Faker::Lorem.characters(number: 16) }
    stripe_status   { "unverified" }
  end
end
