FactoryBot.define do
  factory :branch do
    association :bank, factory: :bank
    code { '000' }
    name { 'STRIPE TEST BRANCH' }
  end
end
