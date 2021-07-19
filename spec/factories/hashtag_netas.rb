FactoryBot.define do
  factory :hashtag_neta do
    trait :with_neta do
      association :neta, factory: :neta
    end
    trait :with_hashtag do
      association :hashtag, factory: :hashtag
    end
  end
end
