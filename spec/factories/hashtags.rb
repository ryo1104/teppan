FactoryBot.define do
  factory :hashtag do
    sequence(:hashname) { |n| "Hashtag #{n}" }
    hit_count { "0" }
    neta_count { "1" }
    trait :with_random_hit_count do
      hit_count { Faker::Number.within(range: 0..1000) }
    end
    trait :with_random_neta_count do
      neta_count { Faker::Number.within(range: 1..10) }
    end
  end
end
