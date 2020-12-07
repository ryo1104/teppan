require 'rails_helper'

RSpec.describe Bank, type: :model do
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

  describe 'method::parse_bank_info' do
    before do
      @stripe_account_obj = valid_stripe_acct_obj
    end
    it 'returns false when stripe_account_obj does not exist' do
      @stripe_account_obj = {}
      expect(Bank.parse_bank_info(@stripe_account_obj)).to eq [false, 'stripe_account_obj does not exist']
    end
    it 'returns false when hash external_accounts does not exist in stripe_account_obj' do
      @stripe_account_obj.delete('external_accounts')
      expect(Bank.parse_bank_info(@stripe_account_obj)).to eq [false, 'external account info is empty']
    end
    it 'returns false when data array does not exist in external_accounts' do
      @stripe_account_obj['external_accounts']['data'] = []
      expect(Bank.parse_bank_info(@stripe_account_obj)).to eq [false, 'external account data is blank']
    end
    it 'returns false when routing number does not exist' do
      @stripe_account_obj['external_accounts']['data'][0].delete('routing_number')
      expect(Bank.parse_bank_info(@stripe_account_obj)).to eq [false, 'routing number hash does not exist']
    end
    it 'returns false when routing number is blank' do
      @stripe_account_obj['external_accounts']['data'][0]['routing_number'] = nil
      expect(Bank.parse_bank_info(@stripe_account_obj)).to eq [false, 'routing number does not exist']
    end
    it 'returns false when routing number is not 7 digits' do
      @stripe_account_obj['external_accounts']['data'][0]['routing_number'] = '111222'
      expect(Bank.parse_bank_info(@stripe_account_obj)).to eq [false, 'routing number is not 7 digits']
    end
    it 'returns false when bank is not found in database' do
      expect(Bank.parse_bank_info(@stripe_account_obj)).to eq [false, 'unable to retrieve bank from database']
    end
    it 'returns false when branch is not found in database' do
      create(:bank, code: '1100')
      expect(Bank.parse_bank_info(@stripe_account_obj)).to eq [false, 'unable to retrieve branch from database']
    end
    it 'returns false when last4 does not exist' do
      test_bank = create(:bank, code: '1100')
      create(:branch, bank: test_bank, code: '000')
      @stripe_account_obj['external_accounts']['data'][0].delete('last4')
      expect(Bank.parse_bank_info(@stripe_account_obj)).to eq [false, 'last4 does not exist']
    end
    it 'returns false when account_holder_name does not exist' do
      test_bank = create(:bank, code: '1100')
      create(:branch, bank: test_bank, code: '000')
      @stripe_account_obj['external_accounts']['data'][0].delete('account_holder_name')
      expect(Bank.parse_bank_info(@stripe_account_obj)).to eq [false, 'account_holder_name does not exist']
    end
    it 'returns bank info' do
      test_bank = create(:bank, code: '1100', name: 'STRIPE TEST BANK')
      create(:branch, bank: test_bank, code: '000', name: 'STRIPE TEST BRANCH')
      expect(Bank.parse_bank_info(@stripe_account_obj)).to eq [true, valid_bank_info]
    end
  end
end
