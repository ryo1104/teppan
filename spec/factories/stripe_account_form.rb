FactoryBot.define do
  factory :stripe_account_form do
    last_name_kanji   { '山田' }
    last_name_kana    { 'ヤマダ' }
    email             { 'kenske' + Faker::Lorem.characters(number: 3) + '@hoge.com' }
  end
end