require 'rails_helper'

RSpec.describe StripeAccountForm, type: :model do
  let(:stripe_inputs_hash) do
    {
      business_type: 'individual',
      individual: {
        last_name: '山田',
        last_name_kanji: '山田',
        last_name_kana: 'ヤマダ',
        first_name: '賢介',
        first_name_kanji: '賢介',
        first_name_kana: 'ケンスケ',
        email: 'kenske@hoge.com',
        gender: '男性',
        dob: { year: '2001', month: '12', day: '6' },
        phone: '+81376332219',
        address_kanji: {
          postal_code: '1010021',
          state: '東京都',
          city: '千代田区',
          town: '外神田２丁目',
          line1: '１５−２−２０１',
          line2: '大山ビル'
        },
        address_kana: {
          line1: '15-2-201',
          line2: 'オオヤマビル'
        }
      },
      type: 'custom',
      country: 'JP',
      tos_acceptance: { date: Time.parse(Time.zone.now.to_s).to_i, ip: '0.0.0.0' },
      settings: {
        payouts: {
          schedule: { interval: 'manual' }
        }
      }
    }
  end
  let(:stripe_account_obj) do
    {
      'id' => 'acct_1FHvBMCx2rPekxgm',
      'object' => 'account',
      'business_profile' =>
      { 'mcc' => nil,
        'name' => nil,
        'product_description' => nil,
        'support_address' => nil,
        'support_email' => nil,
        'support_phone' => nil,
        'support_url' => nil,
        'url' => nil },
      'business_type' => 'individual',
      'capabilities' => { 'legacy_payments' => 'active' },
      'charges_enabled' => false,
      'country' => 'JP',
      'created' => 1_556_620_983,
      'default_currency' => 'jpy',
      'details_submitted' => true,
      'email' => nil,
      'external_accounts' =>
      { 'object' => 'list', 'data' => [], 'has_more' => false, 'total_count' => 0, 'url' => '/v1/accounts/acct_1EUtQQBImRhqCMSQ/external_accounts' },
      'individual' =>
      { 'id' => 'person_Eyr8PiG0EsvSra',
        'object' => 'person',
        'account' => 'acct_1EUtQQBImRhqCMSQ',
        'address_kana' =>
        { 'city' => 'ﾁﾖﾀﾞｸ',
          'country' => 'JP',
          'line1' => '15-2-201',
          'line2' => 'ｵｵﾔﾏﾋﾞﾙ',
          'postal_code' => '1010021',
          'state' => 'ﾄｳｷﾖｳﾄ',
          'town' => 'ｿﾄｶﾝﾀﾞ 2-' },
        'address_kanji' =>
        { 'city' => '千代田区', 'country' => 'JP', 'line1' => '１５−２−２０１', 'line2' => '大山ビル', 'postal_code' => '１０１００２１', 'state' => '東京都', 'town' => '外神田２丁目' },
        'created' => 1_556_620_982,
        'dob' => { 'day' => 24, 'month' => 5, 'year' => 1977 },
        'email' => 'kenske@hoge.com',
        'first_name' => '賢介',
        'first_name_kana' => 'ケンスケ',
        'first_name_kanji' => '賢介',
        'gender' => 'male',
        'last_name' => '山田',
        'last_name_kana' => 'ヤマダ',
        'last_name_kanji' => '山田',
        'metadata' => {},
        'phone' => '+81376332219',
        'relationship' =>
        { 'account_opener' => true, 'director' => false, 'executive' => false, 'owner' => false, 'percent_ownership' => nil, 'title' => nil },
        'requirements' => { 'currently_due' => [], 'eventually_due' => ['verification.document'], 'past_due' => [], 'pending_verification' => [] },
        'verification' =>
        { 'details' => 'Provided identity information could not be verified',
          'details_code' => 'failed_keyed_identity',
          'document' => { 'back' => nil, 'details' => 'Scan failed', 'details_code' => nil, 'front' => nil },
          'status' => 'unverified' } },
      'metadata' => {},
      'payouts_enabled' => false,
      'requirements' =>
        { 'current_deadline' => nil,
          'currently_due' => [],
          'disabled_reason' => 'rejected.other',
          'eventually_due' => [],
          'past_due' => [],
          'pending_verification' => [] },
      'settings' =>
        { 'branding' => { 'icon' => nil, 'logo' => nil, 'primary_color' => nil },
          'card_payments' => { 'decline_on' => { 'avs_failure' => false, 'cvc_failure' => false }, 'statement_descriptor_prefix' => nil },
          'dashboard' => { 'display_name' => nil, 'timezone' => 'Etc/UTC' },
          'payments' => { 'statement_descriptor' => '', 'statement_descriptor_kana' => nil, 'statement_descriptor_kanji' => nil },
          'payouts' =>
          { 'debit_negative_balances' => false,
            'schedule' => { 'delay_days' => 4, 'interval' => 'weekly', 'weekly_anchor' => 'friday' },
            'statement_descriptor' => nil } },
      'tos_acceptance' => { 'date' => 1_566_575_169, 'ip' => '202.32.34.208', 'user_agent' => nil },
      'type' => 'custom'
    }
  end
  let(:stripe_balance_obj) do
    {
      'object' => 'balance',
      'available' => [{ 'amount' => 0, 'currency' => 'jpy', 'source_types' => { 'card' => 0 } }],
      'livemode' => false,
      'pending' => [{ 'amount' => 0, 'currency' => 'jpy', 'source_types' => { 'card' => 0 } }]
    }
  end
  let(:account_info_hash) do
    { 'id' => 'acct_1FHvBMCx2rPekxgm',
      'personal_info' => {
        'last_name_kanji' => '山田',
        'last_name_kana' => 'ヤマダ',
        'first_name_kanji' => '賢介',
        'first_name_kana' => 'ケンスケ',
        'gender' => '男性',
        'email' => 'kenske@hoge.com',
        'dob' => { 'year' => 1977, 'month' => 5, 'day' => 24 },
        'postal_code' => '1010021',
        'kanji_state' => '東京都',
        'kanji_city' => '千代田区',
        'kanji_town' => '外神田２丁目',
        'kanji_line1' => '１５−２−２０１',
        'kanji_line2' => '大山ビル',
        'kana_state' => 'ﾄｳｷﾖｳﾄ',
        'kana_city' => 'ﾁﾖﾀﾞｸ',
        'kana_town' => 'ｿﾄｶﾝﾀﾞ 2-',
        'kana_line1' => '15-2-201',
        'kana_line2' => 'オオヤマビル',
        'phone' => '03-7633-2219',
        'verification' => {
          'details' => 'Provided identity information could not be verified',
          'details_code' => 'failed_keyed_identity',
          'document' => { 'back' => nil, 'details' => 'Scan failed', 'details_code' => nil, 'front' => nil },
          'status' => 'unverified'
        }
      },
      'tos_acceptance' => { 'date' => 1_566_575_169, 'ip' => '202.32.34.208', 'user_agent' => nil },
      'bank_info' => { 'bank_name' => nil, 'branch_name' => nil, 'account_number' => nil, 'account_holder_name' => nil },
      'payouts_enabled' => false,
      'requirements' =>
       { 'current_deadline' => nil, 'currently_due' => [], 'disabled_reason' => 'rejected.other', 'eventually_due' => [], 'past_due' => [] } }
  end
  let(:personal_info_hash) do
    {
      'last_name_kanji' => '山田',
      'last_name_kana' => 'ヤマダ',
      'first_name_kanji' => '賢介',
      'first_name_kana' => 'ケンスケ',
      'gender' => '男性',
      'email' => 'kenske@hoge.com',
      'dob' => { 'year' => 1977, 'month' => 5, 'day' => 24 },
      'postal_code' => '1010021',
      'kanji_state' => '東京都',
      'kanji_city' => '千代田区',
      'kanji_town' => '外神田２丁目',
      'kanji_line1' => '１５−２−２０１',
      'kanji_line2' => '大山ビル',
      'kana_state' => 'ﾄｳｷﾖｳﾄ',
      'kana_city' => 'ﾁﾖﾀﾞｸ',
      'kana_town' => 'ｿﾄｶﾝﾀﾞ 2-',
      'kana_line1' => '15-2-201',
      'kana_line2' => 'オオヤマビル',
      'phone' => '03-7633-2219',
      'verification' => {
        'details' => 'Provided identity information could not be verified',
        'details_code' => 'failed_keyed_identity',
        'document' => { 'back' => nil, 'details' => 'Scan failed', 'details_code' => nil, 'front' => nil },
        'status' => 'unverified'
      }
    }
  end
  let(:personal_info_converted) do
    {
      'last_name_kanji' => '山田',
      'last_name_kana' => 'ヤマダ',
      'first_name_kanji' => '賢介',
      'first_name_kana' => 'ケンスケ',
      'gender' => 'male',
      'email' => 'kenske@hoge.com',
      'dob' => DateTime.new(1977, 5, 24),
      'postal_code' => '1010021',
      'kanji_state' => '東京都',
      'kanji_city' => '千代田区',
      'kanji_town' => '外神田２丁目',
      'kanji_line1' => '１５−２−２０１',
      'kanji_line2' => '大山ビル',
      'kana_state' => 'ﾄｳｷﾖｳﾄ',
      'kana_city' => 'ﾁﾖﾀﾞｸ',
      'kana_town' => 'ｿﾄｶﾝﾀﾞ 2-',
      'kana_line1' => '15-2-201',
      'kana_line2' => 'オオヤマビル',
      'phone' => '03-7633-2219',
      'verification' => {
        'details' => 'Provided identity information could not be verified',
        'details_code' => 'failed_keyed_identity',
        'document' => { 'back' => nil, 'details' => 'Scan failed', 'details_code' => nil, 'front' => nil },
        'status' => 'unverified'
      }
    }
  end
  let(:blank_stripe_account_obj) do
    {
      'id' => 'acct_1EfsQ9DbspCWjyde',
      'object' => 'account',
      'business_profile' => { 'mcc' => nil, 'name' => nil, 'product_description' => nil, 'support_address' => nil, 'support_email' => nil, 'support_phone' => nil, 'support_url' => nil, 'url' => nil },
      'business_type' => 'individual',
      'capabilities' => { 'legacy_payments' => 'active' },
      'charges_enabled' => false,
      'country' => 'JP',
      'created' => 1_559_238_730,
      'default_currency' => 'jpy',
      'details_submitted' => false,
      'email' => nil,
      'external_accounts' => { 'object' => 'list', 'data' => [], 'has_more' => false, 'total_count' => 0, 'url' => '/v1/accounts/acct_1EfsQ9DbspCWjyde/external_accounts' },
      'individual' =>
        {
          'id' => 'person_FACppgeqFMxBQW',
          'object' => 'person',
          'account' => 'acct_1EfsQ9DbspCWjyde',
          'address_kana' => { 'city' => nil, 'country' => 'JP', 'line1' => nil, 'line2' => nil, 'postal_code' => nil, 'state' => nil, 'town' => nil },
          'address_kanji' => { 'city' => nil, 'country' => 'JP', 'line1' => nil, 'line2' => nil, 'postal_code' => nil, 'state' => nil, 'town' => nil },
          'created' => 1_559_238_730,
          'dob' => { 'day' => nil, 'month' => nil, 'year' => nil },
          'email' => 'shunpei@hogehoge.com',
          'first_name_kana' => nil,
          'first_name_kanji' => nil,
          'gender' => 'male',
          'last_name_kana' => nil,
          'last_name_kanji' => nil,
          'metadata' => {},
          'relationship' => { 'account_opener' => true, 'director' => false, 'executive' => false, 'owner' => false, 'percent_ownership' => nil, 'title' => nil },
          'requirements' => { 'currently_due' => ['dob.day', 'dob.month', 'dob.year', 'first_name_kana', 'first_name_kanji', 'last_name_kana', 'last_name_kanji'],
                              'eventually_due' => ['dob.day', 'dob.month', 'dob.year', 'first_name_kana', 'first_name_kanji', 'last_name_kana', 'last_name_kanji'],
                              'past_due' => ['dob.day', 'dob.month', 'dob.year', 'first_name_kana', 'first_name_kanji', 'last_name_kana', 'last_name_kanji'],
                              'pending_verification' => [] },
          'verification' => { 'details' => nil, 'details_code' => nil, 'document' => { 'back' => nil, 'details' => nil, 'details_code' => nil, 'front' => nil }, 'status' => 'unverified' }
        },
      'metadata' => {},
      'payouts_enabled' => false,
      'requirements' =>
        {
          'current_deadline' => nil,
          'currently_due' => ['external_account', 'individual.address_kana.line1', 'individual.address_kanji.line1', 'individual.dob.day', 'individual.dob.month', 'individual.dob.year', 'individual.first_name_kana', 'individual.first_name_kanji', 'individual.last_name_kana', 'individual.last_name_kanji', 'individual.phone', 'tos_acceptance.date', 'tos_acceptance.ip'],
          'disabled_reason' => 'requirements.past_due',
          'eventually_due' => ['external_account', 'individual.address_kana.line1', 'individual.address_kanji.line1', 'individual.dob.day', 'individual.dob.month', 'individual.dob.year', 'individual.first_name_kana', 'individual.first_name_kanji', 'individual.last_name_kana', 'individual.last_name_kanji', 'individual.phone', 'tos_acceptance.date', 'tos_acceptance.ip'],
          'past_due' => ['individual.address_kana.line1', 'individual.address_kanji.line1', 'individual.dob.day', 'individual.dob.month', 'individual.dob.year', 'individual.first_name_kana', 'individual.first_name_kanji', 'individual.last_name_kana', 'individual.last_name_kanji', 'individual.phone'],
          'pending_verification' => []
        },
      'settings' =>
        {
          'branding' => { 'icon' => nil, 'logo' => nil, 'primary_color' => nil },
          'card_payments' => { 'decline_on' => { 'avs_failure' => false, 'cvc_failure' => false },
                               'statement_descriptor_prefix' => nil },
          'dashboard' => { 'display_name' => nil, 'timezone' => 'Etc/UTC' },
          'payments' => { 'statement_descriptor' => '', 'statement_descriptor_kana' => nil, 'statement_descriptor_kanji' => nil },
          'payouts' => { 'debit_negative_balances' => false, 'schedule' => { 'delay_days' => 4, 'interval' => 'weekly', 'weekly_anchor' => 'friday' }, 'statement_descriptor' => nil }
        },
      'tos_acceptance' => { 'date' => nil, 'ip' => nil, 'user_agent' => nil },
      'type' => 'custom'
    }
  end
  let(:blank_personal_info) do
    {
      'last_name_kanji' => nil,
      'last_name_kana' => nil,
      'first_name_kanji' => nil,
      'first_name_kana' => nil,
      'gender' => '男性',
      'email' => 'shunpei@hogehoge.com',
      'dob' => { 'year' => nil, 'month' => nil, 'day' => nil },
      'postal_code' => nil,
      'kanji_state' => nil,
      'kanji_city' => nil,
      'kanji_town' => nil,
      'kanji_line1' => nil,
      'kanji_line2' => nil,
      'kana_state' => nil,
      'kana_city' => nil,
      'kana_town' => nil,
      'kana_line1' => nil,
      'kana_line2' => nil,
      'verification' =>
        {
          'details' => nil,
          'details_code' => nil,
          'document' => { 'back' => nil, 'details' => nil, 'details_code' => nil, 'front' => nil },
          'status' => 'unverified'
        }
    }
  end
  let(:blank_bank_info) do
    { 'bank_name' => nil, 'branch_name' => nil, 'account_number' => nil, 'account_holder_name' => nil }
  end
  let(:filled_personal_info) do
    {
      'last_name_kanji' => '山田',
      'last_name_kana' => 'ヤマダ',
      'first_name_kanji' => '賢介',
      'first_name_kana' => 'ケンスケ',
      'gender' => '男性',
      'email' => 'kenske@hoge.com',
      'dob' => { 'year' => 1977, 'month' => 5, 'day' => 24 },
      'postal_code' => '1010021',
      'kanji_state' => '東京都',
      'kanji_city' => '千代田区',
      'kanji_town' => '外神田２丁目',
      'kanji_line1' => '１５−２−２０１',
      'kanji_line2' => '大山ビル',
      'kana_state' => 'ﾄｳｷﾖｳﾄ',
      'kana_city' => 'ﾁﾖﾀﾞｸ',
      'kana_town' => 'ｿﾄｶﾝﾀﾞ 2-',
      'kana_line1' => '15-2-201',
      'kana_line2' => 'オオヤマビル',
      'phone' => '03-7633-2219',
      'verification' =>
         { 'details' => 'Provided identity information could not be verified',
           'details_code' => 'failed_keyed_identity',
           'document' => { 'back' => nil, 'details' => 'Scan failed', 'details_code' => nil, 'front' => nil },
           'status' => 'unverified' }
    }
  end
  let(:valid_phone_number)    { '+819012345678' }
  let(:invalid_phone_number)  { '+12123456789' }

  describe 'Validations' do
    it 'is invalid without a last_name_kanji' do
      form = build(:stripe_account_form, last_name_kanji: nil)
      form.valid?
      expect(form.errors[:last_name_kanji]).to include('を入力してください。')
    end
    it 'is invalid without a last_name_kana' do
      form = build(:stripe_account_form, last_name_kana: nil)
      form.valid?
      expect(form.errors[:last_name_kana]).to include('を入力してください。')
    end
    it 'is invalid without a first_name_kanji' do
      form = build(:stripe_account_form, first_name_kanji: nil)
      form.valid?
      expect(form.errors[:first_name_kanji]).to include('を入力してください。')
    end
    it 'is invalid without a first_name_kana' do
      form = build(:stripe_account_form, first_name_kana: nil)
      form.valid?
      expect(form.errors[:first_name_kana]).to include('を入力してください。')
    end
    it 'is invalid without a gender' do
      form = build(:stripe_account_form, gender: nil)
      form.valid?
      expect(form.errors[:gender]).to include('を入力してください。')
    end
    it 'is invalid without a email' do
      form = build(:stripe_account_form, email: nil)
      form.valid?
      expect(form.errors[:email]).to include('を入力してください。')
    end
    it 'is invalid without a dob' do
      form = build(:stripe_account_form, dob: nil)
      form.valid?
      expect(form.errors[:dob]).to include('を入力してください。')
    end
    it 'is invalid if underage' do
      form = build(:stripe_account_form, dob: Time.zone.today.prev_year(12))
      form.valid?
      expect(form.errors[:dob]).to include('：13歳未満はご利用できません。')
    end
    it 'is invalid without a postal_code' do
      form = build(:stripe_account_form, postal_code: nil)
      form.valid?
      expect(form.errors[:postal_code]).to include('を入力してください。')
    end
    it 'is invalid without a kanji_state' do
      form = build(:stripe_account_form, kanji_state: nil)
      form.valid?
      expect(form.errors[:kanji_state]).to include('を入力してください。')
    end
    it 'is invalid without a kanji_city' do
      form = build(:stripe_account_form, kanji_city: nil)
      form.valid?
      expect(form.errors[:kanji_city]).to include('を入力してください。')
    end
    it 'is invalid without a kanji_town' do
      form = build(:stripe_account_form, kanji_town: nil)
      form.valid?
      expect(form.errors[:kanji_town]).to include('を入力してください。')
    end
    it 'is invalid without a kanji_line1' do
      form = build(:stripe_account_form, kanji_line1: nil)
      form.valid?
      expect(form.errors[:kanji_line1]).to include('を入力してください。')
    end
    it 'is invalid without a kana_line1' do
      form = build(:stripe_account_form, kana_line1: nil)
      form.valid?
      expect(form.errors[:kana_line1]).to include('を入力してください。')
    end
    it 'is invalid without a phone number' do
      form = build(:stripe_account_form, phone: nil)
      form.valid?
      expect(form.errors[:phone]).to include('が正しくありません。')
    end
    it 'is invalid if not a japan phone number' do
      form = build(:stripe_account_form, phone: '1-800-1234-5678')
      form.valid?
      expect(form.errors[:phone]).to include('が正しくありません。')
    end
    it 'is invalid without user verification' do
      form = build(:stripe_account_form, verification: nil)
      form.valid?
      expect(form.errors[:verification]).to include('を入力してください。')
    end
    it 'is valid with correct inputs' do
      form = build(:stripe_account_form)
      expect(form).to be_valid
    end
  end

  describe 'method::create_inputs' do
    it 'generates params for Stripe' do
      form = build(:stripe_account_form)
      expect(form.create_inputs('0.0.0.0', 'create')).to eq stripe_inputs_hash
    end
  end

  describe 'method::international_phone_number' do
    it 'returns valid phone number' do
      form = build(:stripe_account_form, phone: valid_phone_number)
      expect(form.international_phone_number).to eq '+819012345678'
    end
    it 'returns false when invalid phone number' do
      form = build(:stripe_account_form, phone: invalid_phone_number)
      expect(form.international_phone_number).to eq false
    end
  end

  describe 'method::national_phone_number' do
    it 'returns valid phone number' do
      form = build(:stripe_account_form, phone: valid_phone_number)
      expect(form.national_phone_number).to eq '090-1234-5678'
    end
    it 'returns false when invalid phone number' do
      form = build(:stripe_account_form, phone: invalid_phone_number)
      expect(form.national_phone_number).to eq false
    end
  end

  describe 'method::check_results(stripe_obj)' do
    before do
      @stripe_acct_obj = stripe_account_obj
      @stripe_bal_obj = stripe_balance_obj
    end
    context 'for account object type' do
      it 'returns false when :object does not exist' do
        @stripe_acct_obj.delete('object')
        result = StripeAccountForm.check_results(@stripe_acct_obj)
        expect(result).to match [false, 'params for :object does not exist']
      end
      it 'returns false when :id does not exist' do
        @stripe_acct_obj.delete('id')
        result = StripeAccountForm.check_results(@stripe_acct_obj)
        expect(result).to match [false, 'stripe id does not exist']
      end
      it 'returns false when :individual does not exist' do
        @stripe_acct_obj.delete('individual')
        result = StripeAccountForm.check_results(@stripe_acct_obj)
        expect(result).to match [false, 'params for :individual does not exist']
      end
      it 'returns true otherwise' do
        result = StripeAccountForm.check_results(@stripe_acct_obj)
        expect(result).to match [true, nil]
      end
    end
    context 'for balance object type' do
      it 'returns false when :object does not exist' do
        @stripe_bal_obj.delete('object')
        result = StripeAccountForm.check_results(@stripe_bal_obj)
        expect(result).to match [false, 'params for :object does not exist']
      end
      it 'returns false when :available does not exist' do
        @stripe_bal_obj.delete('available')
        result = StripeAccountForm.check_results(@stripe_bal_obj)
        expect(result).to match [false, 'params for :available does not exist']
      end
      it 'returns false when :pending does not exist' do
        @stripe_bal_obj.delete('pending')
        result = StripeAccountForm.check_results(@stripe_bal_obj)
        expect(result).to match [false, 'params for :pending does not exist']
      end
      it 'returns false when livemode is off' do
        allow(ENV).to receive(:[]).and_call_original # necessary
        allow(ENV).to receive(:[]).with('RAILS_ENV').and_return('production')
        result = StripeAccountForm.check_results(@stripe_bal_obj)
        expect(result).to match [false, 'livemode is set to false']
      end
      it 'returns true otherwise' do
        result = StripeAccountForm.check_results(@stripe_bal_obj)
        expect(result).to match [true, nil]
      end
    end
    context 'for other object types' do
      it 'returns false' do
        @stripe_acct_obj['object'] = 'other_object'
        result = StripeAccountForm.check_results(@stripe_acct_obj)
        expect(result).to match [false, 'unknown stripe object type']
      end
    end
  end

  describe 'method::parse_account_info(stripe_account_hash)' do
    before do
      @stripe_account_obj = stripe_account_obj
    end
    it 'returns false when :check_stripe_results is false' do
      allow(StripeAccountForm).to receive(:check_results).and_return([false, 'some message from check_stripe_results'])
      allow(StripeAccountForm).to receive(:parse_personal_info).and_return([true, filled_personal_info])
      allow(Bank).to receive(:parse_bank_info).and_return([true, nil])

      result = StripeAccountForm.parse_account_info(@stripe_account_obj)
      expect(result).to match [false, 'some message from check_stripe_results']
    end
    it 'returns false when :personal_info is false' do
      allow(StripeAccountForm).to receive(:check_results).and_return([true, nil])
      allow(StripeAccountForm).to receive(:parse_personal_info).and_return([false, 'some message from parse_personal_info'])
      allow(Bank).to receive(:parse_bank_info).and_return([true, nil])

      result = StripeAccountForm.parse_account_info(@stripe_account_obj)
      expect(result).to match [false, 'some message from parse_personal_info']
    end
    it 'returns blank bank info when :parse_bank_info is false' do
      allow(StripeAccountForm).to receive(:check_results).and_return([true, nil])
      allow(StripeAccountForm).to receive(:parse_personal_info).and_return([true, filled_personal_info])
      allow(Bank).to receive(:parse_bank_info).and_return([false, 'some message from parse_bank_info'])
      expected_hash = account_info_hash
      expected_hash['bank_info'] = { 'bank_name' => nil, 'branch_name' => nil, 'account_number' => nil, 'account_holder_name' => nil }

      result = StripeAccountForm.parse_account_info(@stripe_account_obj)
      # 内容が都度変化するものはそのまま結果からコピー
      expected_hash.merge!({ 'requirements' => result[1]['requirements'] })
      expect(result).to match [true, expected_hash]
    end
    it 'returns account information' do
      allow(StripeAccountForm).to receive(:check_results).and_return([true, nil])
      allow(StripeAccountForm).to receive(:parse_personal_info).and_return([true, filled_personal_info])
      allow(Bank).to receive(:parse_bank_info).and_return([true, blank_bank_info])
      expected_hash = account_info_hash
      expected_hash['']

      result = StripeAccountForm.parse_account_info(@stripe_account_obj)
      # 内容が都度変化するものはそのまま結果からコピー
      expected_hash.merge!({ 'requirements' => result[1]['requirements'] })
      expect(result).to match [true, expected_hash]
    end
  end

  describe 'method::parse_personal_info(individual)' do
    context 'blank object' do
      before do
        @stripe_account_obj = blank_stripe_account_obj
        @individual = @stripe_account_obj['individual']
      end
      it 'returns blank personal information' do
        result = StripeAccountForm.parse_personal_info(@individual)
        expect(result).to match [true, blank_personal_info]
      end
    end
    context 'filled object' do
      before do
        @stripe_account_obj = stripe_account_obj
        @individual = @stripe_account_obj['individual']
        @filled_personal_info = filled_personal_info
      end
      it 'returns filled personal information' do
        result = StripeAccountForm.parse_personal_info(@individual)
        expect(result).to match [true, @filled_personal_info]
      end
      it 'returns 男性 if :gender is male' do
        @individual['gender'] = 'male'
        result = StripeAccountForm.parse_personal_info(@individual)
        expect(result[1]['gender']).to eq '男性'
      end
      it 'returns 女性 if :gender is female' do
        @individual['gender'] = 'female'
        result = StripeAccountForm.parse_personal_info(@individual)
        expect(result[1]['gender']).to eq '女性'
      end
    end
  end

  describe 'method::convert_attributes', type: :doing do
    it 'converts stripe retrieved data to form attributes' do
      result = StripeAccountForm.convert_attributes(personal_info_hash)
      expect(result).to eq personal_info_converted
    end
  end
end
