FactoryBot.define do
  factory :pageview do
    sequence(:pageviewable_id) { |n| n }
    trait :as_neta do
      pageviewable :neta
    end
    trait :with_user do
      association :user, factory: :user
    end
  end
end
