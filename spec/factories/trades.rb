FactoryBot.define do
  factory :trade do
    sequence(:buyer_id) { |n| n }
    sequence(:seller_id) { |n| n + 100 }
    stripe_charge_id { 'ch_' + Faker::Lorem.characters(number: 24) }
    price { 100 }
    tradetype { 'TRADE' }
    tradestatus { 'DONE' }
  end
end
