FactoryBot.define do
  factory :stripe_idcard do
    association :stripe_account, factory: :stripe_account
    stripe_file_id { "file_#{Faker::Lorem.characters(number: 24)}" }
    frontback { 'front' }
  end
end
