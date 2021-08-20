require 'rails_helper'

RSpec.describe StripeAccount, type: :model do
  let(:user_create)           { create(:user) }
  let(:test_acct_id)          { 'acct_1FHvBMCx2rPekxgm' } # 山田 賢介
  let(:test_ext_acct_id)      { 'acct_1ETuuMKRzI9hdj1X' } # 山田 祐太郎
  let(:stripe_test_key)       { ENV['STRIPE_SECRET_KEY'] }
  let(:test_env_ip)           { ENV['STRIPE_TEST_REMOTE_IP'] }
  let(:stripe_account_obj)    do
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
  let(:new_acct_params) do
    { business_type: 'individual',
      individual: { last_name: '山田', last_name_kanji: '山田', last_name_kana: 'ヤマダ',
                    first_name: '賢介', first_name_kanji: '賢介', first_name_kana: 'ケンスケ',
                    gender: 'male',
                    dob: { year: '1977', month: '5', day: '24' },
                    address_kanji: { postal_code: '1010021', state: '東京都', city: '千代田区',
                                     town: '外神田３丁目', line1: '１５−２−２０１', line2: '大山ビル' },
                    address_kana: { line1: '15-2-201', line2: 'オオヤマビル' },
                    phone: '+81 3 7633 2219',
                    email: 'kenske@hoge.com' },
      tos_acceptance: { date: 1_566_575_169, ip: '202.32.34.208' },
      type: 'custom',
      country: 'JP' }
  end
  let(:update_acct_params) do # address_kanji->town が 外神田２丁目に変更されているだけ
    { business_type: 'individual',
      individual: { last_name: '山田', last_name_kanji: '山田', last_name_kana: 'ヤマダ',
                    first_name: '賢介', first_name_kanji: '賢介', first_name_kana: 'ケンスケ',
                    gender: 'male',
                    dob: { year: '1977', month: '5', day: '24' },
                    address_kanji: { postal_code: '1010021', state: '東京都', city: '千代田区',
                                     town: '外神田２丁目', line1: '１５−２−２０１', line2: '大山ビル' },
                    address_kana: { line1: '15-2-201', line2: 'オオヤマビル' },
                    phone: '+81 3 7633 2219',
                    email: 'kenske@hoge.com' },
      tos_acceptance: { date: 1_566_575_169, ip: '202.32.34.208' } }
  end
  let(:created_acct_info_hash) do
    {
      'id' => nil,
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
        'kanji_town' => '外神田３丁目',
        'kanji_line1' => '１５−２−２０１',
        'kanji_line2' => '大山ビル',
        'kana_state' => 'ﾄｳｷﾖｳﾄ',
        'kana_city' => 'ﾁﾖﾀﾞｸ',
        'kana_town' => 'ｿﾄｶﾝﾀﾞ 3-',
        'kana_line1' => '15-2-201',
        'kana_line2' => 'ｵｵﾔﾏﾋﾞﾙ',
        'phone' => '03-7633-2219',
        'verification' => {
          'details' => nil,
          'details_code' => nil,
          'document' => { 'back' => nil, 'details' => nil, 'details_code' => nil, 'front' => nil },
          'status' => 'pending'
        }
      },
      'tos_acceptance' => { 'date' => 1_566_575_782, 'ip' => '202.32.34.208', 'user_agent' => nil },
      'bank_info' => { 'bank_name' => nil, 'branch_name' => nil, 'account_number' => nil, 'account_holder_name' => nil },
      'payouts_enabled' => false,
      'requirements' => {
        'current_deadline' => nil,
        'currently_due' => ['external_account'],
        'disabled_reason' => nil,
        'eventually_due' => ['external_account'],
        'past_due' => ['external_account']
      }
    }
  end
  let(:stripe_balance_obj) do
    {
      'object' => 'balance', 'available' => [{ 'amount' => 0, 'currency' => 'jpy', 'source_types' => { 'card' => 0 } }], 'livemode' => false, 'pending' => [{ 'amount' => 0, 'currency' => 'jpy', 'source_types' => { 'card' => 0 } }]
    }
  end
  let(:zero_balance_obj) do
    {
      'object' => 'balance',
      'available' => [{ 'amount' => 0, 'currency' => 'jpy', 'source_types' => { 'card' => 0 } }],
      'livemode' => false,
      'pending' => [{ 'amount' => 0, 'currency' => 'jpy', 'source_types' => { 'card' => 0 } }]
    }
  end
  let(:available_bal_remain) do
    {
      'object' => 'balance',
      'available' => [{ 'amount' => 1, 'currency' => 'jpy', 'source_types' => { 'card' => 0 } }],
      'livemode' => false,
      'pending' => [{ 'amount' => 0, 'currency' => 'jpy', 'source_types' => { 'card' => 0 } }]
    }
  end
  let(:pending_bal_remain) do
    {
      'object' => 'balance',
      'available' => [{ 'amount' => 0, 'currency' => 'jpy', 'source_types' => { 'card' => 0 } }],
      'livemode' => false,
      'pending' => [{ 'amount' => 1, 'currency' => 'jpy', 'source_types' => { 'card' => 0 } }]
    }
  end
  let(:valid_bank_info) { { 'bank_name' => 'STRIPE TEST BANK', 'branch_name' => 'STRIPE TEST BRANCH', 'account_number' => '***1234', 'account_holder_name' => 'ヤマダユウタ' } }
  let(:ext_acct_create_acctid) { 'acct_1FdfXoGJ13miU3q3' } # 銀行 太郎
  let(:ext_acct_create_inputs) do
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
    it 'is valid with a user_id' do
      account = build(:stripe_account, user: user_create)
      expect(account).to be_valid
    end

    it 'is invalid without a user' do
      account = build(:stripe_account, user: nil)
      account.valid?
      expect(account.errors[:user]).to include('を入力してください')
    end

    it 'is invalid if acct_id does not start with acct_' do
      account = build(:stripe_account, user: user_create, acct_id: "aaaa_#{Faker::Lorem.characters(number: 16)}")
      account.valid?
      expect(account.errors[:acct_id]).to include('acct_id does not start with acct_')
    end

    it 'is invalid with a duplicate acct_id' do
      some_user = create(:user)
      create(:stripe_account, user: some_user, acct_id: 'acct_abcdeFGHIJ123456')
      another_user = create(:user)
      account = build(:stripe_account, user: another_user, acct_id: 'acct_abcdeFGHIJ123456')
      account.valid?
      expect(account.errors[:acct_id]).to include('はすでに存在します。')
    end

    it 'is invalid if ext_acct_id does not start with ba_' do
      account = build(:stripe_account, user: user_create, ext_acct_id: "aaaa_#{Faker::Lorem.characters(number: 16)}")
      account.valid?
      expect(account.errors[:ext_acct_id]).to include('ext_acct_id does not start with ba_')
    end
  end

  describe 'method::get_connect_account' do
    before do
      Stripe.api_key = stripe_test_key
    end
    context 'successfully' do
      it 'retrieves account details' do
        account = create(:stripe_account, acct_id: test_acct_id)
        result = account.get_connect_account
        # 内容が都度変化するものはそのまま結果からコピー
        account_info_hash['personal_info'].merge!({ 'verification' => result[1]['personal_info']['verification'] })
        account_info_hash.merge!({ 'requirements' => result[1]['requirements'] })
        account_info_hash.merge!({ 'tos_acceptance' => result[1]['tos_acceptance'] })
        expect(result).to match [true, account_info_hash]
      end
    end
    context 'fails and' do
      it 'returns false with blank acct_id' do
        account = create(:stripe_account, acct_id: nil)
        expect(account.get_connect_account).to match [false, 'acct_id is blank']
      end
      it 'raises exception with invalid inputs' do
        account = create(:stripe_account, acct_id: "#{test_acct_id}aaa")
        expect(account.get_connect_account[1]).to include('Stripe error')
      end
      it 'returns false when parse_account_info returns false' do
        account = create(:stripe_account, acct_id: test_acct_id)
        allow(StripeAccountForm).to receive(:parse_account_info).and_return([false, 'Some parsing error'])
        expect(account.get_connect_account).to match [false, 'error in parse_account_info : Some parsing error']
      end
    end
  end

  describe 'method::create_connect_account' do
    before do
      Stripe.api_key = stripe_test_key
      @acct_form = build(:stripe_account_form)
    end
    context 'successfully' do
      it 'creates connect account' do
        allow(@acct_form).to receive(:create_inputs).and_return(new_acct_params)
        @result = StripeAccount.create_connect_account(@acct_form, test_env_ip)
        expected_hash = created_acct_info_hash
        # 内容が都度変化するものはそのまま結果からコピー
        expected_hash['personal_info']['email'] = @result[1]['personal_info']['email']
        expected_hash['id'] = @result[1]['id']
        expected_hash['personal_info'].merge!({ 'verification' => @result[1]['personal_info']['verification'] })
        expected_hash.merge!({ 'tos_acceptance' => @result[1]['tos_acceptance'] })
        expected_hash.merge!({ 'requirements' => @result[1]['requirements'] })
        expect(@result).to match [true, expected_hash]
      end
    end
    context 'fails and' do
      it 'returns exception with invalid inputs' do
        allow(@acct_form).to receive(:create_inputs).and_return(nil)
        @result = StripeAccount.create_connect_account(@acct_form, test_env_ip)
        expect(@result[1]).to include('Stripe error')
      end
      it 'returns false when parse_account_info returns false' do
        allow(@acct_form).to receive(:create_inputs).and_return(new_acct_params)
        allow(StripeAccountForm).to receive(:parse_account_info).and_return([false, 'Some parsing error'])
        @result = StripeAccount.create_connect_account(@acct_form, test_env_ip)
        expect(@result).to match [false, 'error in parse_account_info : Some parsing error']
      end
    end
    after do
      Stripe::Account.delete(@result[1]['id']) if @result[0]
    end
  end

  describe 'method::update_connect_account' do
    context 'successfully' do
      before do
        Stripe.api_key = stripe_test_key
        @create_result = JSON.parse(Stripe::Account.create(new_acct_params).to_s)
        @account = create(:stripe_account, acct_id: @create_result['id'])
        @acct_form = build(:stripe_account_form)
      end
      it 'updates connect account' do
        allow(@acct_form).to receive(:create_inputs).and_return(update_acct_params)
        expected_hash = created_acct_info_hash
        expected_hash['id'] = @account.acct_id
        expected_hash['personal_info']['kanji_town'] = '外神田２丁目'
        expected_hash['personal_info']['kana_town'] = 'ｿﾄｶﾝﾀﾞ 2-'

        result = @account.update_connect_account(@acct_form, test_env_ip)

        # 内容が都度変化するものはそのまま結果からコピー
        expected_hash['personal_info'].merge!({ 'verification' => result[1]['personal_info']['verification'] })
        expected_hash.merge!({ 'tos_acceptance' => result[1]['tos_acceptance'] })
        expected_hash.merge!({ 'requirements' => result[1]['requirements'] })

        expect(result).to match [true, expected_hash]
      end
      after do
        Stripe::Account.delete(@create_result['id']) if @create_result.key?('id')
      end
    end
    context 'fails and' do
      before do
        Stripe.api_key = stripe_test_key
        @account = create(:stripe_account)
        @acct_form = build(:stripe_account_form)
      end
      it 'returns false with blank acct_id' do
        @account.acct_id = nil
        expect(@account.update_connect_account(@acct_form, test_env_ip)).to match [false, 'acct_id is blank']
      end
      it 'returns exception with invalid inputs' do
        allow(@acct_form).to receive(:create_inputs).and_return(nil)
        result = @account.update_connect_account(@acct_form, test_env_ip)
        expect(result[1]).to include('Stripe error')
      end
      it 'returns false when parse_account_info returns false' do
        allow(@acct_form).to receive(:create_inputs).and_return(update_acct_params)
        allow(Stripe::Account).to receive(:update).and_return({})
        allow(StripeAccountForm).to receive(:parse_account_info).and_return([false, 'Some parsing error'])
        result = @account.update_connect_account(@acct_form, test_env_ip)
        expect(result).to match [false, 'error in parse_account_info : Some parsing error']
      end
    end
  end

  describe 'method::delete_connect_account' do
    context 'successfully' do
      before do
        Stripe.api_key = stripe_test_key
        @create_result = JSON.parse(Stripe::Account.create(new_acct_params).to_s)
        @account = create(:stripe_account, acct_id: @create_result['id'])
      end
      it 'deletes connect account' do
        @result = @account.delete_connect_account
        expect(@result).to match [true, { 'account' => { 'id' => @account.acct_id, 'object' => 'account', 'deleted' => true } }]
      end
      it 'updates status to deleted' do
        @result = @account.delete_connect_account
        expect(@account.status).to eq 'deleted'
      end
      after do
        Stripe::Account.delete(@account.acct_id) if @result[0] == false
      end
    end
    context 'fails and' do
      before do
        Stripe.api_key = stripe_test_key
        @account = create(:stripe_account)
      end
      it 'returns false with blank acct_id' do
        @account.acct_id = nil
        expect(@account.delete_connect_account).to match [false, 'acct_id is blank']
      end
      it 'returns false when balance is not zero' do
        allow(@account).to receive(:zero_balance).and_return(false)
        expect(@account.delete_connect_account).to match [false, 'balance still remains on the account']
      end
      it 'returns exception with invalid inputs' do
        @account.acct_id = 'aaaa_bbbbb'
        allow(@account).to receive(:zero_balance).and_return(true)
        result = @account.delete_connect_account
        expect(result[1]).to include('Stripe error')
      end
      it 'returns false when account status was not updated' do
        allow(@account).to receive(:zero_balance).and_return(true)
        allow(@account).to receive(:update).and_return(false)
        allow(Stripe::Account).to receive(:delete).and_return('{"id": "acct_xxxxxx", "object": "account", "deleted": true}')
        result = @account.delete_connect_account
        expect(result).to match [false, 'account status was not updated']
      end
      it 'returns false when stripe did not delete' do
        allow(@account).to receive(:zero_balance).and_return(true)
        allow(@account).to receive(:update).and_return(true)
        allow(Stripe::Account).to receive(:delete).and_return('{"id": "acct_xxxxxx", "object": "account", "deleted": false}')
        result = @account.delete_connect_account
        expect(result).to match [false, 'account was not deleted for some reason']
      end
    end
  end

  describe 'method::get_balance' do
    it 'retrieves balance details as hash' do
      account = create(:stripe_account, acct_id: test_acct_id)
      expect(account.get_balance).to eq [true, stripe_balance_obj]
    end
    it 'returns false with blank acct_id' do
      account = create(:stripe_account, acct_id: nil)
      expect(account.get_balance).to eq [false, 'acct_id is blank']
    end
    it 'raises exception with invalid acct_id' do
      account = create(:stripe_account, acct_id: "#{test_acct_id}aaa")
      expect(account.get_balance[1]).to include('Stripe error')
    end
    it 'returns false when check_results returns false' do
      account = create(:stripe_account, acct_id: test_acct_id)
      allow(Stripe::Balance).to receive(:retrieve).and_return(stripe_balance_obj.to_json)
      allow(StripeAccountForm).to receive(:check_results).and_return([false, 'some error message from check_results'])
      expect(account.get_balance).to eq [false, 'some error message from check_results']
    end
  end

  describe 'method::zero_balance' do
    it 'returns false when get_stripe_balance returns false' do
      account = create(:stripe_account, acct_id: test_acct_id)
      allow(account).to receive(:get_balance).and_return([false, ''])
      result = account.zero_balance
      expect(result).to eq false
    end
    it 'returns false when available balance is not zero' do
      account = create(:stripe_account, acct_id: test_acct_id)
      allow(account).to receive(:get_balance).and_return([true, available_bal_remain])
      result = account.zero_balance
      expect(result).to eq false
    end
    it 'returns false when pending balance is not zero' do
      account = create(:stripe_account, acct_id: test_acct_id)
      allow(account).to receive(:get_balance).and_return([true, pending_bal_remain])
      result = account.zero_balance
      expect(result).to eq false
    end
    it 'returns true when available balance and pending balance are both zero' do
      account = create(:stripe_account, acct_id: test_acct_id)
      allow(account).to receive(:get_balance).and_return([true, zero_balance_obj])
      result = account.zero_balance
      expect(result).to eq true
    end
  end

  describe 'method::get_ext_account' do
    before do
      Stripe.api_key = stripe_test_key
      @account = create(:stripe_account)
    end
    context 'successfully' do
      it 'retrieves stripe external account' do
        @account.acct_id = test_ext_acct_id
        test_bank = create(:bank)
        create(:branch, bank: test_bank)
        expect(@account.get_ext_account).to eq [true, valid_bank_info]
      end
    end
    context 'fails and' do
      it 'returns false with blank acct_id' do
        @account.acct_id = nil
        expect(@account.get_ext_account).to match [false, 'acct_id is blank']
      end
      it 'raises exception with invalid inputs' do
        @account.acct_id = 'aaaaaaa'
        expect(@account.get_ext_account[1]).to include('Stripe error')
      end
      it 'returns false when parse_bank_info returns false' do
        allow(Stripe::Account).to receive(:retrieve).and_return(stripe_account_obj.to_json)
        allow(Bank).to receive(:parse_bank_info).and_return([false, 'some error'])
        expect(@account.get_ext_account).to eq [false, 'error in parse_bank_info : some error']
      end
    end
  end

  describe 'method::create_ext_account' do
    before do
      Stripe.api_key = stripe_test_key
      @account = create(:stripe_account)
      @account.acct_id = ext_acct_create_acctid
      @stripe_bank_inputs = ext_acct_create_inputs
    end
    context 'successfully' do
      it 'creates stripe external account' do
        expect(@account.create_ext_account(@stripe_bank_inputs)[1]['object']).to eq 'bank_account'
      end
    end
    context 'fails and' do
      it 'returns false with blank acct_id' do
        @account.acct_id = nil
        expect(@account.create_ext_account(@stripe_bank_inputs)).to match [false, 'acct_id is blank']
      end
      it 'returns false with blank params' do
        expect(@account.create_ext_account(nil)).to match [false, 'stripe_bank_inputs is blank']
      end
      it 'returns false if Stripe returned blank result' do
        allow(Stripe::Account).to receive(:create_external_account).and_return(nil)
        expect(@account.create_ext_account(@stripe_bank_inputs)).to match [false, 'Stripe returned nil']
      end
      it 'returns false if no external_account_id is generated' do
        allow(Stripe::Account).to receive(:create_external_account).and_return({ 'somekey' => 'somevalue' }.to_json)
        expect(@account.create_ext_account(@stripe_bank_inputs)).to match [false, 'Failed to create external account']
      end
    end
    after do
      @account.acct_id = ext_acct_create_acctid
      bank_accounts = JSON.parse(Stripe::Account.list_external_accounts(@account.acct_id, { limit: 10, object: 'bank_account' }).to_s)
      bank_accounts['data'].each do |bank_acct|
        Stripe::Account.delete_external_account(@account.acct_id, bank_acct['id']) unless bank_acct['default_for_currency']
      end
    end
  end

  describe 'method::delete_ext_account' do
    before do
      Stripe.api_key = stripe_test_key
      @account = create(:stripe_account)
      @account.acct_id = ext_acct_create_acctid
      @stripe_bank_inputs = ext_acct_create_inputs
      bank_accounts = JSON.parse(Stripe::Account.list_external_accounts(@account.acct_id, { limit: 10, object: 'bank_account' }).to_s)
      bank_accounts['data'].each do |bank_acct|
        @account.ext_acct_id = bank_acct['id'] if bank_acct['default_for_currency']
      end
    end
    context 'successfully' do
      it 'deletes the stripe external account' do
        create_res = @account.create_ext_account(@stripe_bank_inputs)
        old_stripe_bank_id = @account.ext_acct_id
        @account.ext_acct_id = create_res[1]['id']
        expect(@account.delete_ext_account(old_stripe_bank_id)).to eq [true, { 'id' => old_stripe_bank_id, 'object' => 'bank_account', 'currency' => 'jpy', 'deleted' => true }]
      end
    end
    context 'fails and' do
      it 'returns false with blank acct_id' do
        @account.acct_id = nil
        expect(@account.delete_ext_account(@stripe_bank_inputs)).to match [false, 'acct_id is blank']
      end
      it 'returns false with blank ext_acct_id' do
        @account.ext_acct_id = nil
        expect(@account.delete_ext_account(@stripe_bank_inputs)).to match [false, 'ext_acct_id is blank']
      end
      it 'returns false if old_stripe_bank_id is default external account' do
        create_res = @account.create_ext_account(@stripe_bank_inputs)
        old_stripe_bank_id = create_res[1]['id']
        expect(@account.delete_ext_account(old_stripe_bank_id)[1]).to include 'is the default account so it cannot be deleted.'
      end
    end
    after do
      @account.acct_id = ext_acct_create_acctid
      bank_accounts = JSON.parse(Stripe::Account.list_external_accounts(@account.acct_id, { limit: 10, object: 'bank_account' }).to_s)
      bank_accounts['data'].each do |bank_acct|
        Stripe::Account.delete_external_account(@account.acct_id, bank_acct['id']) unless bank_acct['default_for_currency']
      end
    end
  end
end
