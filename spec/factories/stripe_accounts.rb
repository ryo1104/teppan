FactoryBot.define do
  factory :stripe_account do
    association :user, factory: :user
    acct_id { 'acct_' + Faker::Lorem.characters(number: 16) }
    ext_acct_id { 'ba_' + Faker::Lorem.characters(number: 16) }
    status { 'unverified' }
  end
end
