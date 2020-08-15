FactoryBot.define do
  factory :externalaccount do
    association :account, factory: :account
    stripe_bank_id { 'ba_' + Faker::Lorem.characters(number: 16) }
  end
end
