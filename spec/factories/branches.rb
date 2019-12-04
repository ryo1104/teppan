FactoryBot.define do
  factory :branch do
    association :bank, factory: :bank
  end
end
