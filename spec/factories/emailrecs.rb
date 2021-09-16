FactoryBot.define do
  factory :emailrec do
    from { Faker::Internet.email }
    to { Faker::Internet.email }
    subject { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
  end
end
