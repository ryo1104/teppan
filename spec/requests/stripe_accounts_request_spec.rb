require 'rails_helper'

RSpec.describe Business::AccountsController, type: :request do
  let(:user_create) { create(:user) }
  let(:confirm_params_new) do
    {
      'mode' => 'new',
      'stripe_account_form' => {
        'last_name_kanji' => '渡部',
        'last_name_kana' => 'ワタベ',
        'first_name_kanji' => '愛子',
        'first_name_kana' => 'アイコ',
        'gender' => 'female',
        'dob' => '1991-04-20',
        'postal_code' => '1060032',
        'kanji_state' => '東京都',
        'kanji_city' => '港区',
        'kanji_town' => '六本木',
        'kanji_line1' => '7-7-7',
        'kanji_line2' => 'TRI-SEVEN ROPPONGI 13F',
        'kana_line1' => '7-7-7',
        'kana_line2' => 'TRI-SEVEN ROPPONGI 13F',
        'email' => 'kali.howe@johnston.biz',
        'phone' => '03-3122-8876',
        'verification' => '1'
      },
      'commit' => '確認画面へ'
    }
  end
  let(:confirm_params_edit) do
    {
      'mode' => 'edit',
      'stripe_account_form' => {
        'last_name_kanji' => '渡部',
        'last_name_kana' => 'ワタベ',
        'first_name_kanji' => '愛子',
        'first_name_kana' => 'アイコ',
        'gender' => 'female',
        'dob' => '1991-04-20',
        'postal_code' => '1060032',
        'kanji_state' => '東京都',
        'kanji_city' => '港区',
        'kanji_town' => '六本木',
        'kanji_line1' => '7-7-7',
        'kanji_line2' => 'TRI-SEVEN ROPPONGI 13F',
        'kana_line1' => '7-7-7',
        'kana_line2' => 'TRI-SEVEN ROPPONGI 13F',
        'email' => 'kali.howe@johnston.biz',
        'phone' => '03-3122-8876',
        'verification' => '1'
      },
      'commit' => '確認画面へ'
    }
  end
  let(:create_params) do
    {
      'stripe_account_form' => {
        'last_name_kanji' => '渡部',
        'last_name_kana' => 'ワタベ',
        'first_name_kanji' => '愛子',
        'first_name_kana' => 'アイコ',
        'gender' => 'female',
        'dob' => '1991-04-20',
        'postal_code' => '1060032',
        'kanji_state' => '東京都',
        'kanji_city' => '港区',
        'kanji_town' => '六本木',
        'kanji_line1' => '7-7-7',
        'kanji_line2' => 'TRI-SEVEN ROPPONGI 13F',
        'kana_line1' => '7-7-7',
        'kana_line2' => 'TRI-SEVEN ROPPONGI 13F',
        'email' => 'kali.howe@johnston.biz',
        'phone' => '03-3122-8876',
        'verification' => '1'
      }
    }
  end
  let(:update_params) do
    {
      'stripe_account_form' => {
        'last_name_kanji' => '渡部',
        'last_name_kana' => 'ワタベ',
        'first_name_kanji' => '愛子',
        'first_name_kana' => 'アイコ',
        'gender' => 'female',
        'dob' => '1991-04-20',
        'postal_code' => '1060032',
        'kanji_state' => '東京都',
        'kanji_city' => '渋谷区',
        'kanji_town' => '桜丘町',
        'kanji_line1' => '20-1',
        'kanji_line2' => '渋谷インフォスタワー6F',
        'kana_line1' => '20-1',
        'kana_line2' => 'シブヤインフォスタワー6F',
        'email' => 'kali.howe@johnston.biz',
        'phone' => '03-3122-8876',
        'verification' => '1'
      }
    }
  end
  let(:invalid_params) do  # last_name_kana is blank
    {
      'stripe_account_form' => {
        'last_name_kanji' => '渡部',
        'last_name_kana' => '',
        'first_name_kanji' => '愛子',
        'first_name_kana' => 'アイコ',
        'gender' => 'female',
        'dob' => '1991-04-20',
        'postal_code' => '1060032',
        'kanji_state' => '東京都',
        'kanji_city' => '港区',
        'kanji_town' => '六本木',
        'kanji_line1' => '7-7-7',
        'kanji_line2' => 'TRI-SEVEN ROPPONGI 13F',
        'kana_line1' => '7-7-7',
        'kana_line2' => 'TRI-SEVEN ROPPONGI 13F',
        'email' => 'kali.howe@johnston.biz',
        'phone' => '03-3122-8876',
        'verification' => '1'
      }
    }
  end
  let(:created_acct_info_hash) do
    {
      'id' => nil,
      'personal_info' => {
        'last_name_kanji' => '渡部',
        'last_name_kana' => 'ワタベ',
        'first_name_kanji' => '愛子',
        'first_name_kana' => 'アイコ',
        'gender' => '女性',
        'email' => 'kali.howe@johnston.biz',
        'dob' => { 'year' => 1991, 'month' => 4, 'day' => 20 },
        'postal_code' => '1060032',
        'kanji_state' => '東京都',
        'kanji_city' => '港区',
        'kanji_town' => '六本木',
        'kanji_line1' => '7-7-7',
        'kanji_line2' => 'TRI-SEVEN ROPPONGI 13F',
        'kana_state' => 'ﾄｳｷﾖｳﾄ',
        'kana_city' => 'ﾐﾅﾄｸ',
        'kana_town' => 'ﾛｯﾎﾟﾝｷﾞ',
        'kana_line1' => '7-7-7',
        'kana_line2' => 'TRI-SEVEN ROPPONGI 13F',
        'phone' => '03-3122-8876',
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
  let(:updated_acct_info_hash) do
    {
      'id' => nil,
      'personal_info' => {
        'last_name_kanji' => '渡部',
        'last_name_kana' => 'ワタベ',
        'first_name_kanji' => '愛子',
        'first_name_kana' => 'アイコ',
        'gender' => '女性',
        'email' => 'kali.howe@johnston.biz',
        'dob' => { 'year' => 1991, 'month' => 4, 'day' => 20 },
        'postal_code' => '1060032',
        'kanji_state' => '東京都',
        'kanji_city' => '渋谷区',
        'kanji_town' => '桜丘町',
        'kanji_line1' => '20-1',
        'kanji_line2' => '渋谷インフォスタワー6F',
        'kana_state' => 'ﾄｳｷﾖｳﾄ',
        'kana_city' => 'ﾐﾅﾄｸ',
        'kana_town' => 'ﾛｯﾎﾟﾝｷﾞ',
        'kana_line1' => '20-1',
        'kana_line2' => 'シブヤインフォスタワー6F',
        'phone' => '03-3122-8876',
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
  let(:verified_acct_info_hash) do
    { 'id' => 'acct_1JRf7SRCqRPv2EJa',
      'personal_info' =>
       { 'last_name_kanji' => '斉藤',
         'last_name_kana' => 'サイトウ',
         'first_name_kanji' => '弘太郎',
         'first_name_kana' => 'コウタロウ',
         'gender' => '男性',
         'email' => 'koutaro@hogehoge.com',
         'dob' => { 'year' => 1980, 'month' => 10, 'day' => 21 },
         'postal_code' => '1410021',
         'kanji_state' => '東京都',
         'kanji_city' => '品川区',
         'kanji_town' => '上大崎',
         'kanji_line1' => '3-1-1',
         'kanji_line2' => 'アトレ目黒２',
         'kana_state' => 'ﾄｳｷﾖｳﾄ',
         'kana_city' => 'ｼﾅｶﾞﾜｸ',
         'kana_town' => 'ｶﾐｵｵｻｷ 3-',
         'kana_line1' => '3-1-1',
         'kana_line2' => 'アトレメグロ2',
         'phone' => '03-5435-0001',
         'verification' =>
         { 'additional_document' => { 'back' => nil, 'details' => nil, 'details_code' => nil, 'front' => nil },
           'details' => nil,
           'details_code' => nil,
           'document' => { 'back' => nil, 'details' => nil, 'details_code' => nil, 'front' => 'file_1JRfbJEThOtNwrS9DxNcIgYy' },
           'status' => 'verified' } },
      'tos_acceptance' => { 'date' => 1_629_732_660, 'ip' => '175.177.44.117', 'user_agent' => nil },
      'bank_info' => { 'bank_name' => 'STRIPE TEST BANK', 'branch_name' => 'STRIPE TEST BRANCH', 'account_number' => '***1234', 'account_holder_name' => 'サイトウコウタロウ' },
      'payouts_enabled' => true,
      'requirements' =>
       { 'alternatives' => [],
         'current_deadline' => nil,
         'currently_due' => [],
         'disabled_reason' => nil,
         'errors' => [],
         'eventually_due' => [],
         'past_due' => [],
         'pending_verification' => [] } }
  end

  describe 'GET #new' do
    subject { get new_user_account_url(@user.id) }

    before do
      @user = user_create
    end
    context 'as a signed in user' do
      before do
        sign_in @user
      end
      context "when not qualified to create seller's account" do
        before do
          allow_any_instance_of(User).to receive(:premium_user).and_return([false, nil, nil])
        end
        it 'redirects to user#show' do
          subject
          expect(response).to redirect_to user_url(@user.id)
          expect(response).to have_http_status('302')
        end
      end
      context 'when accessing for different user' do
        before do
          @another_user = create(:user)
        end
        it 'redirects to user#show ' do
          get new_user_account_url(@another_user.id)
          expect(response).to redirect_to user_url(@user.id)
          expect(response).to have_http_status('302')
        end
      end
      context 'with a fresh session' do
        it 'displays blank form' do
          allow_any_instance_of(User).to receive(:premium_user).and_return([true, nil, nil])
          subject
          expect(response.body).to include 'お客様情報'
          expect(response).to have_http_status('200')
        end
      end
      context 'when rendering back from confirm screen' do
        it 'displays filled form' do
          allow_any_instance_of(User).to receive(:premium_user).and_return([true, nil, nil])
          get new_user_account_url(@user.id), params: { mode: 'new', stripe_account_form: { last_name_kanji: '田中' } }
          expect(response.body).to include '田中'
        end
      end
    end
    context 'as a guest' do
      it 'redirects to user sign-in page' do
        subject
        expect(response).to redirect_to new_user_session_url
        expect(response).to have_http_status('302')
      end
    end
  end

  describe 'POST #confirm' do  # this is for new -> confirm -> create
    subject { post confirm_user_accounts_url(@user.id), params: confirm_params_new }

    before do
      @user = user_create
    end
    context 'as a signed in user' do
      before do
        sign_in @user
      end
      it 'displays form info to be confirmed' do
        subject
        expect(response.body).to include 'お名前（漢字）'
        expect(response).to have_http_status('200')
      end
    end
    context 'as a guest' do
      it 'redirects to user sign-in page' do
        subject
        expect(response).to redirect_to new_user_session_url
        expect(response).to have_http_status('302')
      end
    end
  end

  describe 'PATCH #confirm' do # this is for edit -> confirm -> update
    subject { patch confirm_account_url(@account.id), params: confirm_params_edit }

    before do
      @user = user_create
      @account = create(:stripe_account, user: @user)
    end
    context 'as a signed in user' do
      before do
        sign_in @user
      end
      it 'displays info to be confirmed' do
        subject
        expect(response.body).to include 'お名前（漢字）'
        expect(response).to have_http_status('200')
      end
    end
    context 'as a guest' do
      it 'redirects to user sign-in page' do
        subject
        expect(response).to redirect_to new_user_session_url
        expect(response).to have_http_status('302')
      end
    end
  end

  describe 'POST #create' do
    subject { post user_accounts_url(@user.id), params: @test_params }

    before do
      @user = user_create
      @test_params = create_params
    end
    context 'as a signed in user' do
      before do
        sign_in @user
      end
      it 'redirects to current_user#show when not my page' do
        @another_user = create(:user)
        post user_accounts_url(@another_user.id), params: @create_params
        expect(response).to redirect_to user_url(@user.id)
        expect(response).to have_http_status('302')
      end
      it 'redirects to user#show when not qualified for premium plan' do
        allow_any_instance_of(User).to receive(:premium_user).and_return([false, nil, nil])
        subject
        expect(response).to redirect_to user_url(@user.id)
        expect(response).to have_http_status('302')
      end
      context 'qualified for premium plan' do
        before do
          allow_any_instance_of(User).to receive(:premium_user).and_return([true, nil, nil])
        end
        it 'renders filled form when back button pressed in confirm screen (params[:back] exists)' do
          @test_params.merge!({ 'back' => '入力画面に戻る' }) # 戻るボタンが押された
          subject
          expect(response.body).to include '渡部'
          expect(response).to have_http_status('200')
        end
        it 'renders filled form with error message when form is invalid' do
          @test_params = invalid_params
          subject
          expect(response).to have_http_status('200')
          expect(response.body).to include('姓（カナ）を入力してください')
        end
        it 'redirects to user#show if stripe returns error' do
          allow(StripeAccount).to receive(:create_connect_account).and_return([false, 'some kind of Stripe error'])
          subject
          expect(response).to redirect_to user_url(@user.id)
        end
        it 'redirects to user#show if Active Record save returns error' do
          allow(StripeAccount).to receive(:create_connect_account).and_return([true, created_acct_info_hash])
          allow_any_instance_of(StripeAccount).to receive(:save).and_return(false)
          subject
          expect(response).to redirect_to user_url(@user.id)
        end
        it 'redirects to account#show when Stripe Connect and Active Record both succeeds creating account' do
          allow(StripeAccount).to receive(:create_connect_account).and_return([true, created_acct_info_hash])
          subject
          new_account = StripeAccount.last
          expect(response).to redirect_to account_url(new_account.id)
          expect(response).to have_http_status('302')
        end
      end
    end
    context 'as a guest' do
      it 'redirects to user sign-in page' do
        subject
        expect(response).to redirect_to new_user_session_url
        expect(response).to have_http_status('302')
      end
    end
  end

  describe 'GET #edit' do
    subject { get edit_account_url(@account.id) }

    before do
      @user = user_create
      @account = create(:stripe_account, user: @user, acct_id: 'acct_1JQDTsRErzrZuQBE') # 渡部 愛子のStripe Connect
    end
    context 'as a signed in user' do
      before do
        sign_in @user
      end
      it 'displays form with current info' do
        subject
        expect(response.body).to include '渡部'
        expect(response).to have_http_status('200')
      end
      it 'redirects to current_user#show when not my account' do
        @another_user = create(:user)
        @another_account = create(:stripe_account, user: @another_user, acct_id: 'acct_1JVzHnRDIeZClgoy') # 菅原 蓮のStripe Connect
        get edit_account_url(@another_account.id)
        expect(response).to redirect_to user_url(@user.id)
        expect(response).to have_http_status('302')
      end
      it 'redirects to account#show when Stripe connect returns error' do
        allow_any_instance_of(StripeAccount).to receive(:get_connect_account).and_return([false, 'some error message'])
        subject
        expect(response).to redirect_to account_url(@account.id)
        expect(response).to have_http_status('302')
      end
      it 'redirects to account#show when convert attributes returns error' do
        allow(StripeAccountForm).to receive(:convert_attributes).and_return([false, 'some error message'])
        subject
        expect(response).to redirect_to account_url(@account.id)
        expect(response).to have_http_status('302')
      end
    end
    context 'as a guest' do
      it 'redirects to user sign-in page' do
        subject
        expect(response).to redirect_to new_user_session_url
        expect(response).to have_http_status('302')
      end
    end
  end

  describe 'PATCH #update' do
    subject { patch account_url(@account.id), params: @test_params }

    before do
      @user = user_create
      @account = create(:stripe_account, user: @user, acct_id: 'acct_1JQDTsRErzrZuQBE') # 渡部 愛子のStripe Connect
      @test_params = update_params # create_params から住所を変更
    end
    context 'as a signed in user' do
      before do
        sign_in @user
      end
      it 'redirects to current_user#show when not my page' do
        @another_user = create(:user)
        @another_account = create(:stripe_account, user: @another_user, acct_id: 'acct_1JVzHnRDIeZClgoy') # 菅原 蓮のStripe Connect
        patch account_url(@another_account.id), params: @test_params
        expect(response).to redirect_to user_url(@user.id)
        expect(response).to have_http_status('302')
      end
      it 'renders edit when back button pressed in confirm screen (params[:back] exists)' do
        @test_params.merge!({ 'back' => '入力画面に戻る' }) # 戻るボタンが押された
        subject
        expect(response.body).to include '桜丘町' # 更新しようとした内容
        expect(response).to have_http_status('200')
      end
      it 'redirects to account#edit when Stripe connect returns error' do
        allow_any_instance_of(StripeAccount).to receive(:update_connect_account).and_return([false, 'some kind of Stripe error message'])
        subject
        expect(response).to redirect_to edit_account_url(@account.id)
        expect(response).to have_http_status('302')
      end
      it 'redirects to account#edit when Active Record update returns false' do
        allow_any_instance_of(StripeAccount).to receive(:update_connect_account).and_return([true, updated_acct_info_hash])
        allow_any_instance_of(StripeAccount).to receive(:update).and_return(false)
        subject
        expect(response).to redirect_to edit_account_url(@account.id)
        expect(response).to have_http_status('302')
      end
      it 'redirects to account#show when update is successful' do
        allow_any_instance_of(StripeAccount).to receive(:update_connect_account).and_return([true, updated_acct_info_hash])
        allow_any_instance_of(StripeAccount).to receive(:update).and_return(true)
        subject
        expect(response).to redirect_to account_url(@account.id)
        expect(response).to have_http_status('302')
      end
    end
    context 'as a guest' do
      it 'redirects to user sign-in page' do
        subject
        expect(response).to redirect_to new_user_session_url
        expect(response).to have_http_status('302')
      end
    end
  end

  describe 'GET #show' do
    subject { get account_url(@account.id) }

    before do
      @user = user_create
    end
    context 'as a signed in user' do
      before do
        sign_in @user
      end
      context 'when status is not Verified' do
        before do
          @account = create(:stripe_account, user: @user, acct_id: 'acct_1JQDTsRErzrZuQBE') # 渡部 愛子のStripe Connect
        end
        it 'redirects to current_user#show when not my page' do
          @another_user = create(:user)
          @another_account = create(:stripe_account, user: @another_user, acct_id: 'acct_1JVzHnRDIeZClgoy') # 菅原 蓮のStripe Connect
          get account_url(@another_account.id)
          expect(response).to redirect_to user_url(@user.id)
          expect(response).to have_http_status('302')
        end
        it 'redirects to current_user#show when Stripe connect returns error' do
          allow_any_instance_of(StripeAccount).to receive(:get_connect_account).and_return([false, 'some kind of Stripe error message'])
          subject
          expect(response).to redirect_to user_url(@user.id)
          expect(response).to have_http_status('302')
        end
        it 'redirects to current_user#show when refresh_status returns false' do
          allow_any_instance_of(StripeAccount).to receive(:update).and_return(false)
          subject
          expect(response).to redirect_to user_url(@user.id)
          expect(response).to have_http_status('302')
        end
        it 'displays idcards upload buttons' do
          allow_any_instance_of(StripeAccount).to receive(:get_connect_account).and_return([true, created_acct_info_hash])
          subject
          expect(response.body).to include '表面：'
          expect(response.body).to include '裏面：'
        end
      end
      context 'when status is Verified' do
        before do
          @account = create(:stripe_account, user: @user, acct_id: 'acct_1JRf7SRCqRPv2EJa') # 斉藤 弘太郎のStripe Connect
        end
        it 'displays connect account information' do
          subject
          expect(response.body).to include '上大崎'
          expect(response).to have_http_status('200')
        end
        it 'displays bank account' do
          subject
          expect(response.body).to include '出金先 銀行口'
          expect(response).to have_http_status('200')
        end
        it 'displays balances' do
          subject
          expect(response.body).to include '出金可能'
          expect(response).to have_http_status('200')
        end
        it 'displays id card as verified' do
          subject
          expect(response.body).to include '確認済'
          expect(response).to have_http_status('200')
        end
      end
    end
    context 'as a guest' do
      before do
        @account = create(:stripe_account, user: @user, acct_id: 'acct_1JRf7SRCqRPv2EJa') # 斉藤 弘太郎のStripe Connect
      end
      it 'redirects to user sign-in page' do
        subject
        expect(response).to redirect_to new_user_session_url
        expect(response).to have_http_status('302')
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete account_url(@account.id) }

    before do
      @user = user_create
      @account = create(:stripe_account, user: @user, acct_id: 'acct_1JRf7SRCqRPv2EJa') # 斉藤 弘太郎のStripe Connect
    end
    context 'as a signed in user' do
      before do
        sign_in @user
      end
      it 'redirects to current_user#show when not my page' do
        @another_user = create(:user)
        @another_account = create(:stripe_account, user: @another_user, acct_id: 'acct_1JVzHnRDIeZClgoy') # 菅原 蓮のStripe Connect
        delete account_url(@another_account.id)
        expect(response).to redirect_to user_url(@user.id)
        expect(response).to have_http_status('302')
      end
      it 'redirects to account#show when balance still remaining' do
        allow_any_instance_of(StripeAccount).to receive(:zero_balance).and_return(false)
        subject
        expect(response).to redirect_to account_url(@account.id)
        expect(response).to have_http_status('302')
      end
      it 'redirects to account#show when Stripe connect returns error' do
        allow_any_instance_of(StripeAccount).to receive(:zero_balance).and_return(true)
        allow_any_instance_of(StripeAccount).to receive(:delete_connect_account).and_return([false, 'some Stripe error'])
        subject
        expect(response).to redirect_to account_url(@account.id)
        expect(response).to have_http_status('302')
      end
      it 'redirects to account#show when Active Record destroy returns false' do
        allow_any_instance_of(StripeAccount).to receive(:zero_balance).and_return(true)
        allow_any_instance_of(StripeAccount).to receive(:delete_connect_account).and_return([true, { 'account' => { 'id' => @account.acct_id, 'object' => 'account', 'deleted' => true } }])
        allow_any_instance_of(StripeAccount).to receive(:destroy).and_return(false)
        subject
        expect(response).to redirect_to account_url(@account.id)
        expect(response).to have_http_status('302')
      end
      it 'redirects to user#show when destroy is successful' do
        allow_any_instance_of(StripeAccount).to receive(:zero_balance).and_return(true)
        allow_any_instance_of(StripeAccount).to receive(:delete_connect_account).and_return([true, { 'account' => { 'id' => @account.acct_id, 'object' => 'account', 'deleted' => true } }])
        allow_any_instance_of(StripeAccount).to receive(:destroy).and_return(true)
        subject
        expect(response).to redirect_to user_url(@user.id)
        expect(response).to have_http_status('302')
      end
    end
    context 'as a guest' do
      it 'redirects to user sign-in page' do
        subject
        expect(response).to redirect_to new_user_session_url
        expect(response).to have_http_status('302')
      end
    end
  end
end
