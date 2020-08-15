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
  let(:valid_bank_info) { { 'bank_name' => 'STRIPE TEST BANK', 'branch_name' => 'STRIPE TEST BRANCH', 'account_number' => '***1234', 'account_holder_name' => 'ヤマダユウタ' } }
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

  describe 'method::get_stripe_ext_account' do
    before do
      @account = account_create
      @ext_account = FactoryBot.create(:externalaccount, account: @account)
    end
    it 'returns false when stripe_acct_id is blank' do
      @account.stripe_acct_id = nil
      expect(@ext_account.get_stripe_ext_account).to eq [false, 'stripe_acct_id is blank']
    end
    it 'returns false when Stripe returns exception' do
      @account.stripe_acct_id = 'aaaaaa'
      expect(@ext_account.get_stripe_ext_account[0]).to eq false
    end
    it 'returns false when parse_bank_info returns false' do
      @account.stripe_acct_id = valid_stripe_acct_id
      allow(Externalaccount).to receive(:parse_bank_info).and_return([false, 'some error'])
      expect(@ext_account.get_stripe_ext_account).to eq [false, 'error in parse_bank_info : some error']
    end
    it 'returns true and bank info' do
      @account.stripe_acct_id = valid_stripe_acct_id
      allow(Externalaccount).to receive(:parse_bank_info).and_return([true, valid_bank_info])
      expect(@ext_account.get_stripe_ext_account).to eq [true, valid_bank_info]
    end
  end

  describe 'method::create_stripe_ext_account' do
    before do
      @account = account_create
      @account.stripe_acct_id = nil
      @stripe_bank_inputs = {}
      @ext_acct = FactoryBot.build(:externalaccount, account: @account, stripe_bank_id: nil)
    end
    it 'returns false when stripe_bank_inputs is blank' do
      expect(@ext_acct.create_stripe_ext_account(@stripe_bank_inputs)).to eq [false, 'bank_params is blank']
    end
    it 'returns false when stripe account id is blank' do
      @stripe_bank_inputs = stripe_bank_acct_post_inputs
      expect(@ext_acct.create_stripe_ext_account(@stripe_bank_inputs)).to eq [false, 'stripe_acct_id is blank']
    end
    it 'returns false when Stripe returns exception' do
      @account.stripe_acct_id = 'aaaaaa'
      expect(@ext_acct.create_stripe_ext_account(@stripe_bank_inputs)[0]).to eq false
    end
    context 'with valid inputs' do
      before do
        @account.stripe_acct_id = stripe_bank_acct_post_test_user
        @stripe_bank_inputs = stripe_bank_acct_post_inputs
      end
      it 'returns bank info' do
        expect(@ext_acct.create_stripe_ext_account(@stripe_bank_inputs)[1]['object']).to eq 'bank_account'
      end
      after do
        bank_accounts = JSON.parse(Stripe::Account.list_external_accounts(@account.stripe_acct_id, { limit: 10, object: 'bank_account' }).to_s)
        bank_accounts['data'].each do |bank_acct|
          unless bank_acct['default_for_currency']
            Stripe::Account.delete_external_account(@account.stripe_acct_id, bank_acct['id'])
          end
        end
      end
    end
  end

  describe 'method::delete_stripe_ext_account' do
    before do
      @account = account_create
      @account.stripe_acct_id = nil
      @stripe_bank_id = nil
      @ext_acct = FactoryBot.build(:externalaccount, account: @account, stripe_bank_id: @stripe_bank_id)
    end
    it 'returns false when stripe_bank_id is blank' do
      expect(@ext_acct.delete_stripe_ext_account(@stripe_bank_id)).to eq [false, 'stripe_bank_id is blank']
    end
    it 'returns false when stripe_acct_id is blank' do
      @stripe_bank_id = 'aaaaaa'
      expect(@ext_acct.delete_stripe_ext_account(@stripe_bank_id)).to eq [false, 'stripe_acct_id is blank']
    end
    it 'returns false when Stripe returns exception' do
      @stripe_bank_id = 'aaaaaa'
      @account.stripe_acct_id = 'bbbbbb'
      expect(@ext_acct.delete_stripe_ext_account(@stripe_bank_id)[0]).to eq false
    end
    context 'with valid inputs' do
      before do
        @account.stripe_acct_id = stripe_bank_acct_post_test_user
        @bank_account_obj = stripe_bank_acct_post_inputs
        Stripe::Account.create_external_account(@account.stripe_acct_id, @bank_account_obj)
        bank_accounts = JSON.parse(Stripe::Account.list_external_accounts(@account.stripe_acct_id, { limit: 10, object: 'bank_account' }).to_s)
        bank_accounts['data'].each do |bank_acct|
          @stripe_bank_id = bank_acct['id'] unless bank_acct['default_for_currency']
        end
      end
      it 'returns deleted flag as true' do
        expect(@ext_acct.delete_stripe_ext_account(@stripe_bank_id)[1]['deleted']).to eq true
      end
    end
  end

  describe 'method::parse_bank_info' do
    before do
      @stripe_account_obj = valid_stripe_acct_obj
    end
    it 'returns false when stripe_account_obj does not exist' do
      @stripe_account_obj = {}
      expect(Externalaccount.parse_bank_info(@stripe_account_obj)).to eq [false, 'stripe_account_obj does not exist']
    end
    it 'returns false when hash external_accounts does not exist in stripe_account_obj' do
      @stripe_account_obj.delete('external_accounts')
      expect(Externalaccount.parse_bank_info(@stripe_account_obj)).to eq [false, 'external account information does not exist in stripe account obj']
    end
    it 'returns false when data array does not exist in external_accounts' do
      @stripe_account_obj['external_accounts']['data'] = []
      expect(Externalaccount.parse_bank_info(@stripe_account_obj)).to eq [false, 'external account data is blank']
    end
    it 'returns false when routing number does not exist' do
      @stripe_account_obj['external_accounts']['data'][0].delete('routing_number')
      expect(Externalaccount.parse_bank_info(@stripe_account_obj)).to eq [false, 'routing number hash does not exist']
    end
    it 'returns false when routing number is blank' do
      @stripe_account_obj['external_accounts']['data'][0]['routing_number'] = nil
      expect(Externalaccount.parse_bank_info(@stripe_account_obj)).to eq [false, 'routing number does not exist']
    end
    it 'returns false when routing number is not 7 digits' do
      @stripe_account_obj['external_accounts']['data'][0]['routing_number'] = '111222'
      expect(Externalaccount.parse_bank_info(@stripe_account_obj)).to eq [false, 'routing number is not 7 digits']
    end
    it 'returns false when bank is not found in database' do
      expect(Externalaccount.parse_bank_info(@stripe_account_obj)).to eq [false, 'unable to retrieve bank from database']
    end
    it 'returns false when branch is not found in database' do
      FactoryBot.create(:bank, code: '1100')
      expect(Externalaccount.parse_bank_info(@stripe_account_obj)).to eq [false, 'unable to retrieve branch from database']
    end
    it 'returns false when last4 does not exist' do
      test_bank = FactoryBot.create(:bank, code: '1100')
      FactoryBot.create(:branch, bank: test_bank, code: '000')
      @stripe_account_obj['external_accounts']['data'][0].delete('last4')
      expect(Externalaccount.parse_bank_info(@stripe_account_obj)).to eq [false, 'last4 does not exist']
    end
    it 'returns false when account_holder_name does not exist' do
      test_bank = FactoryBot.create(:bank, code: '1100')
      FactoryBot.create(:branch, bank: test_bank, code: '000')
      @stripe_account_obj['external_accounts']['data'][0].delete('account_holder_name')
      expect(Externalaccount.parse_bank_info(@stripe_account_obj)).to eq [false, 'account_holder_name does not exist']
    end
    it 'returns bank info' do
      test_bank = FactoryBot.create(:bank, code: '1100', name: 'STRIPE TEST BANK')
      FactoryBot.create(:branch, bank: test_bank, code: '000', name: 'STRIPE TEST BRANCH')
      expect(Externalaccount.parse_bank_info(@stripe_account_obj)).to eq [true, valid_bank_info]
    end
  end
end
