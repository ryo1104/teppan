FactoryBot.define do
  factory :hashtag do
    hashname { "Hashtag#{Faker::Lorem.characters(number: 8)}" }
    hiragana { 'てすと' }
    hit_count { '0' }
    neta_count { '0' }
    trait :with_random_hit_count do
      hit_count { Faker::Number.within(range: 0..1000) }
    end
    trait :with_random_neta_count do
      neta_count { Faker::Number.within(range: 1..10) }
    end
  end
end
