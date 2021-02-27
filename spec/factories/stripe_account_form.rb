FactoryBot.define do
  factory :stripe_account_form do
    last_name_kanji   { '山田' }
    last_name_kana    { 'ヤマダ' }
    first_name_kanji  { '賢介' }
    first_name_kana   { 'ケンスケ' }
    gender            { '男性' }
    email             { 'kenske' + '@hoge.com' }
    dob               { DateTime.new(2001, 12, 6, 0, 0, 0) }
    postal_code       { '1010021' }
    kanji_state       { '東京都' }
    kanji_city        { '千代田区' }
    kanji_town        { '外神田２丁目' }
    kanji_line1       { '１５−２−２０１' }
    kanji_line2       { '大山ビル' }
    kana_state        { 'ﾄｳｷﾖｳ' }
    kana_city         { 'ﾁﾖﾀﾞｸ' }
    kana_town         { 'ｿﾄｶﾝﾀﾞ 2-' }
    kana_line1        { '15-2-201' }
    kana_line2        { 'ｵｵﾔﾏﾋﾞﾙ' }
    phone             { '+81376332219' }
    verification      { true }
  end
end
