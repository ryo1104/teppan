FactoryBot.define do
  factory :hashtag_hit, class: 'HashtagHit' do
    trait :with_hashtag do
      association :hashtag, factory: :hashtag
    end
  end
end
