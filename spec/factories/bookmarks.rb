FactoryBot.define do
  factory :bookmark do
    trait :with_user do
      association :user, factory: :user
    end
  end
end
