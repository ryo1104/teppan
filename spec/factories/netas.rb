FactoryBot.define do
  factory :neta do
    # sequence(:text) { |n| "Neta text with over 20 characters #{n}" }
    title { 'ネタテスト　タイトル' }
    content { 'ネタテスト　本文' }
    price { '0' }
    private_flag { false }
    trait :with_user do
      association :user, factory: :user
    end
    trait :with_topic do
      association :topic, factory: :topic
    end
    trait :with_valuetext do
      sequence(:valuetext) { |n| "Neta valuetext with over 20 characters #{n}" }
    end
    trait :with_hashtags do
      after(:create) do |neta|
        create_list(:hashtag, 3, netas: [neta])
      end
    end
  end
end
