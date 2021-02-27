FactoryBot.define do
  factory :stripe_payout do
    association :stripe_account, factory: :stripe_account
    payout_id { 'po_' + Faker::Lorem.characters(number: 16) }
    amount { 100 }
  end
end
