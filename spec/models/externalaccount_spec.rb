require 'rails_helper'

RSpec.describe Externalaccount, type: :model do
  let(:user_create)           { FactoryBot.create(:user) }
  let(:account_create)        { FactoryBot.create(:account) }
  let(:valid_stripe_acct_id)  { 'acct_1ETuuMKRzI9hdj1X' } # 山田 祐太郎
  let(:valid_stripe_acct_obj) do
    {
      'id' => 'acct_1ETuuMKRzI9hdj1X',
      'object' => 'account',
      'business_profile' => {
        'mcc' => nil,
        'name' => nil,
        'product_description' => nil,
        'support_address' => nil,
        'support_email' => nil,
        'support_phone' => nil,
        'support_url' => nil,
        'url' => nil
      },
      'business_type' => 'individual',
      'capabilities' => { 'legacy_payments' => 'active' },
      'charges_enabled' => true,
      'country' => 'JP',
      'created' => 1_556_388_355,
      'default_currency' => 'jpy',
      'details_submitted' => true,
      'email' => nil,
      'external_accounts' => {
        'object' => 'list',
        'data' =>
          [
            { 'id' => 'ba_1EUriWKRzI9hdj1XQKUZ9t2F', 'object' => 'bank_account', 'account' => 'acct_1ETuuMKRzI9hdj1X', 'account_holder_name' => 'ヤマダユウタ', 'account_holder_type' => nil, 'bank_name' => 'STRIPE TEST BANK', 'country' => 'JP', 'currency' => 'jpy', 'default_for_currency' => true, 'fingerprint' => 'eRGYiacjmout7RFL', 'last4' => '1234', 'metadata' => {}, 'routing_number' => '1100000', 'status' => 'new' }
          ],
        'has_more' => false, 'total_count' => 1, 'url' => '/v1/accounts/acct_1ETuuMKRzI9hdj1X/external_accounts'
      },
      'individual' => {
        'id' => 'person_Exr42qwL2KsGSw',
        'object' => 'person',
        'account' => 'acct_1ETuuMKRzI9hdj1X',
        'address_kana' => {
          'city' => 'ﾒｸﾞﾛｸ',
          'country' => 'JP',
          'line1' => '3-5',
          'line2' => 'オオヤマビル',
          'postal_code' => '1520035',
          'state' => 'ﾄｳｷﾖｳﾄ',
          'town' => 'ｼﾞﾕｳｶﾞｵｶ 1-'
        },
        'address_kanji' => {
          'city' => '目黒区',
          'country' => 'JP',
          'line1' => '3-5',
          'line2' => '大山ビル',
          'postal_code' => '１５２００３５',
          'state' => '東京都',
          'town' => '自由が丘1'
        },
        'created' => 1_556_390_084,
        'dob' => { 'day' => 21, 'month' => 10, 'year' => 1982 },
        'email' => 'yutaro@hoge.com',
        'first_name' => '祐太郎', 'first_name_kana' => 'ユウタロウ', 'first_name_kanji' => '祐太郎',
        'gender' => 'male',
        'last_name' => '山田', 'last_name_kana' => 'ヤマダ', 'last_name_kanji' => '山田',
        'metadata' => {},
        'phone' => '+81391464157',
        'relationship' => { 'account_opener' => true, 'director' => false, 'executive' => false, 'owner' => false, 'percent_ownership' => nil, 'representative' => true, 'title' => nil },
        'requirements' => { 'currently_due' => [], 'eventually_due' => [], 'past_due' => [], 'pending_verification' => [] },
        'verification' => {
          'additional_document' => { 'back' => nil, 'details' => nil, 'details_code' => nil, 'front' => nil },
          'details' => nil,
          'details_code' => nil,
          'document' => {
            'back' => 'file_1EWSjDKRzI9hdj1XwoZu6EGq',
            'details' => nil,
            'details_code' => nil,
            'front' => 'file_1EWSneKRzI9hdj1XrE0Q14Cm'
          },
          'status' => 'verified'
        }
      },
      'metadata' => {},
      'payouts_enabled' => true,
      'requirements' => {
        'current_deadline' => nil, 'currently_due' => [], 'disabled_reason' => nil, 'eventually_due' => [], 'past_due' => [], 'pending_verification' => []
      },
      'settings' => {
        'branding' => { 'icon' => nil, 'logo' => nil, 'primary_color' => nil },
        'card_payments' => {
          'decline_on' => { 'avs_failure' => false, 'cvc_failure' => false },
          'statement_descriptor_prefix' => nil
        },
        'dashboard' => { 'display_name' => nil, 'timezone' => 'Etc/UTC' },
        'payments' => { 'statement_descriptor' => '', 'statement_descriptor_kana' => nil, 'statement_descriptor_kanji' => nil },
        'payouts' => { 'debit_negative_balances' => false, 'schedule' => { 'delay_days' => 4, 'interval' => 'manual' }, 'statement_descriptor' => nil }
      },
      'tos_acceptance' => { 'date' => 1_556_468_406, 'ip' => '202.32.34.208', 'user_agent' => nil }, 'type' => 'custom'
    }
  end
  let(:stripe_bank_acct_post_test_user) { 'acct_1FdfXoGJ13miU3q3' } # 銀行 太郎
  let(:stripe_bank_acct_post_inputs)    do
    {
      external_account:
      {
        object: 'bank_account',
        account_number: '0001234',
        routing_number: '1100000', # 銀行コード4けた+支店コード3けた
        account_holder_name: 'ギンコウタロウ', # カタカナでなければStripeエラー
        currency: 'jpy',
        country: 'jp'
      },
      default_for_currency: 'true'
    }
  end

  describe 'Validations' do
    it 'is valid with a account id' do
      ext_account = build(:externalaccount, account: account_create)
      expect(ext_account).to be_valid
    end
    it 'is invalid without a account id' do
      ext_account = build(:externalaccount, account: nil)
      ext_account.valid?
      expect(ext_account.errors[:account]).to include('を入力してください')
    end
    it 'is invalid with duplicate account ids' do
      some_account = account_create
      FactoryBot.create(:externalaccount, account_id: some_account.id)
      ext_account = build(:externalaccount, account_id: some_account.id)
      ext_account.valid?
      expect(ext_account.errors[:account_id]).to include('はすでに存在します。')
    end
  end


end
