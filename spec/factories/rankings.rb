FactoryBot.define do
  factory :ranking do
    trait :as_neta do
      rankable_type { 'Neta' }
    end
  end
end
