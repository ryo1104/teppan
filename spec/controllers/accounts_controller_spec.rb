require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  let(:user_create)             { FactoryBot.create(:user) }
  let(:test_stripe_acct_id)     { 'acct_1EUtQQBImRhqCMSQ' }
  let(:good_input)              do
    {
      'last_name_kanji' => '山田',
      'last_name_kana' => 'ヤマダ',
      'first_name_kanji' => '賢介',
      'first_name_kana' => 'ケンスケ',
      'gender' => '男性',
      'email' => 'kenske@hoge.com',
      'birthdate(1i)' => 1977,
      'birthdate(2i)' => 5,
      'birthdate(3i)' => 24,
      'postal_code' => '1010021',
      'state' => '東京都',
      'city' => '千代田区',
      'town' => '外神田２丁目',
      'kanji_line1' => '１５−２−２０１',
      'kanji_line2' => '大山ビル',
      'kana_line1' => '15-2-201',
      'kana_line2' => 'ｵｵﾔﾏﾋﾞﾙ',
      'phone' => '+81376332219',
      'user_agreement' => 'false'
    }
  end
  let(:filtered_good_params) do
    {
      business_type: 'individual',
      individual: {
        last_name: '山田',
        last_name_kanji: '山田',
        last_name_kana: 'ヤマダ',
        first_name: '賢介',
        first_name_kanji: '賢介',
        first_name_kana: 'ケンスケ',
        gender: '男性',
        dob: { year: '1977', month: '5', day: '24' },
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
        },
        phone: '+81376332219',
        email: 'kenske@hoge.com'
      },
      type: 'custom',
      country: 'JP'
    }
  end
  let(:account_info_hash) do
    { 'id' => 'acct_1EUtQQBImRhqCMSQ',
      'personal_info' =>
       { 'last_name_kanji' => '山田',
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
         'kana_line2' => 'ｵｵﾔﾏﾋﾞﾙ',
         'phone' => '+81376332219',
         'verification' =>
         { 'additional_document' => { 'back' => nil, 'details' => nil, 'details_code' => nil, 'front' => nil },
           'details' => 'Provided identity information could not be verified',
           'details_code' => 'failed_keyed_identity',
           'document' => { 'back' => nil, 'details' => 'Scan failed', 'details_code' => nil, 'front' => nil },
           'status' => 'unverified' } },
      'tos_acceptance' => { 'date' => 1_566_575_169, 'ip' => '202.32.34.208', 'user_agent' => nil },
      'bank_info' => { 'bank_name' => nil, 'branch_name' => nil, 'account_number' => nil, 'account_holder_name' => nil },
      'payouts_enabled' => false,
      'requirements' =>
       { 'current_deadline' => nil, 'currently_due' => [], 'disabled_reason' => 'rejected.other', 'eventually_due' => [], 'past_due' => [], 'pending_verification' => [] } }
  end
  let(:created_acct_info_hash) do
    {
      'id' => 'acct_' + Faker::Lorem.characters(number: 16),
      'personal_info' => {
        'verification' => {
          'details' => nil,
          'details_code' => nil,
          'document' => { 'back' => nil, 'details' => nil, 'details_code' => nil, 'front' => nil },
          'status' => 'pending'
        }
      }
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
  let(:stripe_delete_success) { { 'account' => { 'id' => test_stripe_acct_id, 'object' => 'account', 'deleted' => true } } }
  render_views

  describe 'GET #new', type: :doing do
    context 'as an authenticated user' do
      before do
        @user = user_create
        sign_in @user
      end
      context "when not qualified to create seller's account" do
        before do
          allow(@user).to receive(:premium_user).and_return(false)
        end
        it 'redirects to user#show' do
          get :new, params: { user_id: @user.id }
          expect(response).to redirect_to "/users/#{@user.id}"
        end
        it 'returns a 302 status code' do
          get :new, params: { user_id: @user.id }
          expect(response).to have_http_status('302')
        end
      end
      context 'when accessing for different user' do
        before do
          @another_user = create(:user)
        end
        it 'redirects to user#show ' do
          get :new, params: { user_id: @another_user.id }
          expect(response).to redirect_to "/users/#{@user.id}"
        end
        it 'returns a 302 status code' do
          get :new, params: { user_id: @another_user.id }
          expect(response).to have_http_status('302')
        end
      end
      it 'renders the :new template' do
        allow(controller).to receive(:qualified).and_return(true)
        get :new, params: { user_id: @user.id }
        expect(response).to render_template :new
      end
      it 'returns a 200 status code' do
        allow(controller).to receive(:qualified).and_return(true)
        get :new, params: { user_id: @user.id }
        expect(response).to have_http_status('200')
      end
      it 'redirects to user#show when account already exists' do
        create(:account, user: @user)
        get :new, params: { user_id: @user.id }
        expect(response).to redirect_to "/users/#{@user.id}"
      end
      it 'returns a 302 status code when account already exists' do
        create(:account, user: @user)
        get :new, params: { user_id: @user.id }
        expect(response).to have_http_status('302')
      end
    end
    context 'as a guest' do
      before do
        @user = user_create
      end
      it 'returns a 302 status code' do
        get :new, params: { user_id: @user.id }
        expect(response).to have_http_status('302')
      end
      it 'redirects to user sign-in page' do
        get :new, params: { user_id: @user.id }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'POST #create' do
    context 'as an authenticated user' do
      before do
        @user = user_create
        sign_in @user
      end
      context "when not qualified to create seller's account" do
        before do
          allow(controller).to receive(:qualified).and_return(false)
        end
        it 'redirects to user#show' do
          post :create, params: { user_id: @user.id }
          expect(response).to redirect_to "/users/#{@user.id}"
        end
        it 'returns a 302 status code' do
          post :create, params: { user_id: @user.id }
          expect(response).to have_http_status('302')
        end
      end
      context 'when accessing for different user' do
        before do
          @another_user = create(:user)
        end
        it 'redirects to user#show' do
          post :create, params: { user_id: @another_user.id }
          expect(response).to redirect_to "/users/#{@user.id}"
        end
        it 'returns a 302 status code' do
          post :create, params: { user_id: @another_user.id }
          expect(response).to have_http_status('302')
        end
      end
      context 'when Stripe account creation is successful' do
        before do
          allow(controller).to receive(:qualified).and_return(true)
          allow(Account).to receive(:create_stripe_account).and_return([true, created_acct_info_hash])
        end
        it 'filters permitted params' do
          @params_to_test = good_input.merge!(user_id: @user.id)
          @params_to_test.merge!(evil_input: 'some input')
          post :create, params: @params_to_test
          expect(controller.instance_eval { new_account_params }).to eq filtered_good_params
        end
        it 'creates an account' do
          expect do
            post :create, params: { user_id: @user.id }
          end.to change(Account, :count).by(1)
        end
        it 'returns a 302 status code' do
          post :create, params: { user_id: @user.id }
          expect(response).to have_http_status('302')
        end
        it 'redirects to account#show' do
          post :create, params: { user_id: @user.id }
          new_account = Account.last
          expect(response).to redirect_to "/accounts/#{new_account.id}"
        end
      end
      context 'when Stripe account creation failed' do
        before do
          allow(controller).to receive(:qualified).and_return(true)
          allow(Account).to receive(:create_stripe_account).and_return([false, 'some reason of Stripe account failure'])
        end
        it 'writes to Rails logger an error message' do
          expect(Rails.logger).to receive(:error).with('create_stripe_account returned false : some reason of Stripe account failure')
          post :create, params: { user_id: @user.id }
        end
        it 'redirects to user#show' do
          post :create, params: { user_id: @user.id }
          expect(response).to redirect_to "/users/#{@user.id}"
        end
        it 'returns a 302 status code' do
          post :create, params: { user_id: @user.id }
          expect(response).to have_http_status('302')
        end
      end
    end
    context 'as a guest' do
      before do
        @user = user_create
      end
      it 'returns a 302 status code' do
        post :create, params: { user_id: @user.id }
        expect(response).to have_http_status('302')
      end
      it 'redirects to user sign-in page' do
        post :create, params: { user_id: @user.id }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
    context 'exceptions' do
      before do
        @user = user_create
        sign_in @user
      end
      it 'redirects to user#show for Stripe::PermissionError' do
        allow(Account).to receive(:create_stripe_account).and_raise(Stripe::PermissionError)
        post :create, params: { user_id: @user.id }
        expect(response).to redirect_to "/users/#{@user.id}"
      end
      it 'redirects to account#new for general exceptions' do
        allow(controller).to receive(:qualified).and_raise(StandardError)
        post :create, params: { user_id: @user.id }
        expect(response).to redirect_to "/users/#{@user.id}/accounts/new"
      end
    end
  end

  describe 'GET #show' do
    context 'as an authenticated user' do
      before do
        @user = user_create
        sign_in @user
        @test_account = create(:account, user: @user, stripe_acct_id: test_stripe_acct_id)
      end
      context 'when Stripe account retrieval is successful' do
        before do
          allow_any_instance_of(Account).to receive(:get_stripe_account).and_return([true, account_info_hash])
          allow_any_instance_of(Account).to receive(:get_stripe_balance).and_return([true, stripe_balance_obj])
        end
        it 'populates @account' do
          get :show, params: { id: @test_account.id }
          expect(assigns(:account)).to match(@test_account)
        end
        it 'populates @account_info from Stripe' do
          get :show, params: { id: @test_account.id }
          expect(assigns(:account_info)).to match(account_info_hash)
        end
        it "updates record's stripe_status" do
          @verified_account_info = account_info_hash
          @verified_account_info['personal_info']['verification']['status'] = 'verified'
          allow_any_instance_of(Account).to receive(:get_stripe_account).and_return([true, @verified_account_info])

          get :show, params: { id: @test_account.id }
          expect(@test_account.reload.stripe_status).to eq 'verified'
        end
        it 'populates @balance_info' do
          get :show, params: { id: @test_account.id }
          expect(assigns(:balance_info)).to match(stripe_balance_obj)
        end
        it 'renders the show template' do
          get :show, params: { id: @test_account.id }
          expect(response).to render_template :show
        end
        it 'returns a 200 status code' do
          get :show, params: { id: @test_account.id }
          expect(response).to have_http_status('200')
        end
      end
      context 'when Stripe account retrieval failed' do
        before do
          allow_any_instance_of(Account).to receive(:get_stripe_account).and_return([false, 'some error in retrieving stripe account'])
        end
        it 'redirects to user#show' do
          get :show, params: { id: @test_account.id }
          expect(response).to redirect_to "/users/#{@user.id}"
        end
        it 'writes to Rails logger an error message' do
          expect(Rails.logger).to receive(:error).with('get_stripe_account returned false : some error in retrieving stripe account')
          get :show, params: { id: @test_account.id }
        end
      end
      context 'when Stripe balance retrieval failed' do
        before do
          allow_any_instance_of(Account).to receive(:get_stripe_account).and_return([true, account_info_hash])
          allow_any_instance_of(Account).to receive(:get_stripe_balance).and_return([false, 'some error in retrieving stripe balance'])
        end
        it 'redirects to user#show' do
          get :show, params: { id: @test_account.id }
          expect(response).to redirect_to "/users/#{@user.id}"
        end
        it 'writes to Rails logger an error message' do
          expect(Rails.logger).to receive(:error).with('get_stripe_balance returned false : some error in retrieving stripe balance')
          get :show, params: { id: @test_account.id }
        end
      end
      context 'when different user than the account owner' do
        before do
          sign_out @user
          @another_user = create(:user)
          sign_in @another_user
        end
        it 'redirects to user#show' do
          get :show, params: { id: @test_account.id }
          expect(response).to redirect_to "/users/#{@another_user.id}"
        end
      end
    end

    context 'as a guest' do
      before do
        @test_account = create(:account, user: user_create, stripe_acct_id: test_stripe_acct_id)
      end
      it 'returns a 302 status code' do
        get :show, params: { id: @test_account.id }
        expect(response).to have_http_status('302')
      end
      it 'redirects to user sign-in page' do
        get :show, params: { id: @test_account.id }
        expect(response).to redirect_to '/users/sign_in'
      end
    end

    context 'exceptions' do
      before do
        @user = user_create
        sign_in @user
        @test_account = create(:account, user: @user, stripe_acct_id: test_stripe_acct_id)
      end
      it 'rescues from Stripe::PermissionError' do
        allow(controller).to receive(:show).and_raise(Stripe::PermissionError)
        expect do
          get :show, params: { id: @test_account.id }
        end.to raise_error(Stripe::PermissionError)
      end
      it 'redirects to user#show for Stripe::PermissionError' # do
      #   allow(controller).to receive(:show).and_raise(Stripe::PermissionError)
      #   subject { get :show, params: { id: @test_account.id } }
      #   expect(subject).to redirect_to "/users/#{@user.id}"
      # end

      it 'rescues from general exceptions' do
        allow(controller).to receive(:show).and_raise(StandardError)
        expect do
          get :show, params: { id: @test_account.id }
        end.to raise_error(StandardError)
      end
    end
  end

  describe 'GET #edit' do
    context 'as an authenticated user' do
      before do
        @user = user_create
        sign_in @user
        @test_account = create(:account, user: @user, stripe_acct_id: test_stripe_acct_id)
      end

      context 'when Stripe account retrieval is successful' do
        before do
          allow_any_instance_of(Account).to receive(:get_stripe_account).and_return([true, account_info_hash])
        end
        it 'populates @account' do
          get :edit, params: { id: @test_account.id }
          expect(assigns(:account)).to match(@test_account)
        end
        it 'populates @account_info' do
          get :edit, params: { id: @test_account.id }
          expect(assigns(:account_info)).to match(account_info_hash)
        end
        it 'renders the edit template' do
          get :edit, params: { id: @test_account.id }
          expect(response).to render_template :edit
        end
        it 'returns a 200 status code' do
          get :edit, params: { id: @test_account.id }
          expect(response).to have_http_status('200')
        end
      end
      context 'when Stripe account retrieval failed' do
        before do
          allow_any_instance_of(Account).to receive(:get_stripe_account).and_return([false, 'some error in retrieving stripe account'])
        end
        it 'writes to Rails logger an error message' do
          expect(Rails.logger).to receive(:error).with('get_stripe_account returned false : some error in retrieving stripe account')
          get :edit, params: { id: @test_account.id }
        end
        it 'redirects to user#show' do
          get :edit, params: { id: @test_account.id }
          expect(response).to redirect_to "/users/#{@user.id}"
        end
      end
      context 'as a different user' do
        before do
          sign_out @user
          @another_user = create(:user)
          sign_in @another_user
        end
        it 'redirects to user#show' do
          get :edit, params: { id: @test_account.id }
          expect(response).to redirect_to "/users/#{@another_user.id}"
        end
      end
    end

    context 'as a guest' do
      before do
        @test_account = create(:account, user: user_create, stripe_acct_id: test_stripe_acct_id)
      end
      it 'returns a 302 status code' do
        get :edit, params: { id: @test_account.id }
        expect(response).to have_http_status('302')
      end
      it 'redirects to user sign-in page' do
        get :edit, params: { id: @test_account.id }
        expect(response).to redirect_to '/users/sign_in'
      end
    end

    context 'exceptions' do
      before do
        @user = user_create
        sign_in @user
        @test_account = create(:account, user: @user, stripe_acct_id: test_stripe_acct_id)
      end
      it 'rescues from Stripe::PermissionError' do
        allow(controller).to receive(:edit).and_raise(Stripe::PermissionError)
        expect  do
          get :edit, params: { id: @test_account.id }
        end.to raise_error(Stripe::PermissionError)
      end
      it 'redirects to user#show for Stripe::PermissionError'
      it 'rescues from general exceptions' do
        allow(controller).to receive(:edit).and_raise(StandardError)
        expect  do
          get :edit, params: { id: @test_account.id }
        end.to raise_error(StandardError)
      end
    end
  end

  describe 'POST #update' do
    context 'as an authenticated user' do
      before do
        @user = user_create
        sign_in @user
        @test_account = create(:account, user: @user, stripe_acct_id: test_stripe_acct_id)
      end
      it 'populates @account' do
        patch :update, params: { id: @test_account.id }
        expect(assigns(:account)).to match(@test_account)
      end
      context 'when Stripe account update is successful' do
        it 'populates @account_info' do
          allow_any_instance_of(Account).to receive(:update_stripe_account).and_return([true, account_info_hash])
          patch :update, params: { id: @test_account.id }
          expect(assigns(:account_info)).to match(account_info_hash)
        end
        it "updates record's stripe_status" do
          @verified_account_info = account_info_hash
          @verified_account_info['personal_info']['verification']['status'] = 'verified'
          allow_any_instance_of(Account).to receive(:update_stripe_account).and_return([true, @verified_account_info])

          patch :update, params: { id: @test_account.id }
          expect(@test_account.reload.stripe_status).to eq 'verified'
        end
        it 'does not change record count' do
          expect { patch :update, params: { id: @test_account.id } }.to change(Account, :count).by(0)
        end
        it 'redirects to account#show' do
          allow_any_instance_of(Account).to receive(:update_stripe_account).and_return([true, account_info_hash])
          patch :update, params: { id: @test_account.id }
          expect(response).to redirect_to "/accounts/#{@test_account.id}"
        end
        it 'returns a 302 status code' do
          allow_any_instance_of(Account).to receive(:update_stripe_account).and_return([true, account_info_hash])
          patch :update, params: { id: @test_account.id }
          expect(response).to have_http_status('302')
        end
      end
      context 'when Stripe account update failed' do
        before do
          allow_any_instance_of(Account).to receive(:update_stripe_account).and_return([false, 'some error in updating stripe account'])
        end
        it 'redirects to account#edit' do
          patch :update, params: { id: @test_account.id }
          expect(response).to redirect_to "/accounts/#{@test_account.id}/edit"
        end
        it 'returns a 302 status code' do
          patch :update, params: { id: @test_account.id }
          expect(response).to have_http_status('302')
        end
        it 'writes to Rails logger an error message' do
          expect(Rails.logger).to receive(:error).with('update_stripe_account returned false : some error in updating stripe account')
          patch :update, params: { id: @test_account.id }
        end
      end
      context 'as a different user' do
        before do
          sign_out @user
          @another_user = create(:user)
          sign_in @another_user
        end
        it 'redirects to user#show' do
          patch :update, params: { id: @test_account.id }
          expect(response).to redirect_to "/users/#{@another_user.id}"
        end
      end
    end
    context 'as a guest' do
      before do
        @test_account = create(:account, user: user_create, stripe_acct_id: test_stripe_acct_id)
      end
      it 'returns a 302 status code' do
        patch :update, params: { id: @test_account.id }
        expect(response).to have_http_status('302')
      end
      it 'redirects to user sign-in page' do
        patch :update, params: { id: @test_account.id }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
    context 'exceptions' do
      before do
        @user = user_create
        sign_in @user
        @test_account = create(:account, user: @user, stripe_acct_id: test_stripe_acct_id)
      end
      it 'rescues from Stripe::PermissionError' do
        allow(controller).to receive(:update).and_raise(Stripe::PermissionError)
        expect do
          get :update, params: { id: @test_account.id }
        end.to raise_error(Stripe::PermissionError)
      end
      it 'redirects to user#show for Stripe::PermissionError'

      it 'rescues from general exceptions' do
        allow(controller).to receive(:update).and_raise(StandardError)
        expect do
          get :update, params: { id: @test_account.id }
        end.to raise_error(StandardError)
      end
    end
  end
  describe 'DELETE #destroy' do
    context 'as an authenticated user' do
      before do
        @user = user_create
        sign_in @user
        @test_account = create(:account, user: @user, stripe_acct_id: test_stripe_acct_id)
      end
      it 'populates @account' do
        delete :destroy, params: { id: @test_account.id }
        expect(assigns(:account)).to match(@test_account)
      end
      it 'redirects to account#show if account balance is not zero' do
        allow_any_instance_of(Account).to receive(:zero_balance).and_return(false)
        delete :destroy, params: { id: @test_account.id }
        expect(response).to redirect_to "/accounts/#{@test_account.id}"
      end
      context 'when Stripe account delete is successful' do
        before do
          allow_any_instance_of(Account).to receive(:zero_balance).and_return(true)
          allow_any_instance_of(Account).to receive(:delete_stripe_account).and_return([true, stripe_delete_success])
        end
        it 'populates @delete_result' do
          delete :destroy, params: { id: @test_account.id }
          expect(assigns(:delete_result)).to match(stripe_delete_success)
        end
        it 'changes record count by -1' do
          expect { delete :destroy, params: { id: @test_account.id } }.to change(Account, :count).by(-1)
        end
      end
      context 'when Stripe account delete failed' do
        before do
          allow_any_instance_of(Account).to receive(:zero_balance).and_return(true)
          allow_any_instance_of(Account).to receive(:delete_stripe_account).and_return([false, 'some error in deleting stripe account'])
        end
        it 'redirects to account#show' do
          delete :destroy, params: { id: @test_account.id }
          expect(response).to redirect_to "/accounts/#{@test_account.id}"
        end
        it 'returns a 302 status code' do
          delete :destroy, params: { id: @test_account.id }
          expect(response).to have_http_status('302')
        end
        it 'writes to Rails logger an error message' do
          expect(Rails.logger).to receive(:error).with('delete_stripe_account returned false : some error in deleting stripe account')
          delete :destroy, params: { id: @test_account.id }
        end
      end
      context 'as a different user' do
        before do
          sign_out @user
          @another_user = create(:user)
          sign_in @another_user
        end
        it 'redirects to user#show' do
          delete :destroy, params: { id: @test_account.id }
          expect(response).to redirect_to "/users/#{@another_user.id}"
        end
      end
    end
    context 'as a guest' do
      before do
        @test_account = create(:account, user: user_create, stripe_acct_id: test_stripe_acct_id)
      end
      it 'returns a 302 status code' do
        delete :destroy, params: { id: @test_account.id }
        expect(response).to have_http_status('302')
      end
      it 'redirects to user sign-in page' do
        delete :destroy, params: { id: @test_account.id }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
    context 'exceptions' do
      before do
        @user = user_create
        sign_in @user
        @test_account = create(:account, user: @user, stripe_acct_id: test_stripe_acct_id)
      end
      it 'rescues from Stripe::PermissionError' do
        allow(controller).to receive(:destroy).and_raise(Stripe::PermissionError)
        expect do
          delete :destroy, params: { id: @test_account.id }
        end.to raise_error(Stripe::PermissionError)
      end
      it 'redirects to user#show for Stripe::PermissionError'

      it 'rescues from general exceptions' do
        allow(controller).to receive(:destroy).and_raise(StandardError)
        expect do
          delete :destroy, params: { id: @test_account.id }
        end.to raise_error(StandardError)
      end
    end
  end
end
