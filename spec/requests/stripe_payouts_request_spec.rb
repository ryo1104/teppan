require 'rails_helper'

RSpec.describe Business::PayoutsController, type: :request do
  let(:user_create)             { create(:user) }
  let(:valid_stripe_acct_id)    { 'acct_1JQDTsRErzrZuQBE' } # Stripe Connect test account 渡部 愛子
  let(:valid_stripe_acct_id2)   { 'acct_1HdBU2EyhQyqSyxV' } # Stripe Connect test account 佐藤 雄太郎
  let(:valid_ext_acct_id)       { 'ba_1JQDWJRErzrZuQBEYwYoTYzh' }
  let(:valid_payout_id)         { 'po_1JSkoMRErzrZuQBEeOAVACRe' }

  describe 'GET #new' do
    subject { get new_account_payout_url(@account.id) }
    before do
      @user = user_create
      stripe_test_bank = create(:bank)
      create(:branch, bank: stripe_test_bank)
    end
    context 'as a signed in user' do
      before do
        sign_in @user
      end
      context 'successfully' do
        before do
          @account = create(:stripe_account, user: @user, acct_id: valid_stripe_acct_id, ext_acct_id: valid_ext_acct_id)
        end
        it 'displays payout form' do
          subject
          expect(response.body).to include '銀行口座へ出金'
          expect(response).to have_http_status('200')
        end
      end
      context 'if current user is not account owner' do
        before do
          @another_user = create(:user)
          @account = create(:stripe_account, user: @another_user, acct_id: valid_stripe_acct_id2)
        end
        it 'redirects to current user page' do
          subject
          expect(response).to redirect_to user_url(@user.id)
          expect(flash[:alert]).to include '権限がありません。'
          expect(response).to have_http_status('302')
        end
      end
      context 'if bank info is not found' do
        before do
          @account = create(:stripe_account, user: @user, acct_id: valid_stripe_acct_id, ext_acct_id: valid_ext_acct_id)
          allow_any_instance_of(StripeAccount).to receive(:get_ext_account).and_return([false, 'some error message'])
        end
        it 'redirects to current user page' do
          subject
          expect(response).to redirect_to user_url(@user.id)
          expect(flash[:alert]).to include '振込先口座情報が取得できませんでした。'
          expect(response).to have_http_status('302')
        end
      end
      context 'if balance cannot be retrieved' do
        before do
          @account = create(:stripe_account, user: @user, acct_id: valid_stripe_acct_id, ext_acct_id: valid_ext_acct_id)
          allow_any_instance_of(StripeAccount).to receive(:get_balance).and_return([false, 'some error message'])
        end
        it 'redirects to account#show' do
          subject
          expect(response).to redirect_to account_url(@account.id)
          expect(flash[:alert]).to include '出金可能額を取得できませんでした。'
          expect(response).to have_http_status('302')
        end
      end
    end
    context 'as a guest' do
      before do
        @account = create(:stripe_account, user: @user, acct_id: valid_stripe_acct_id, ext_acct_id: valid_ext_acct_id)
      end
      it 'redirects to the sign-in page' do
        subject
        expect(response).to redirect_to new_user_session_url
        expect(response).to have_http_status('302')
      end
    end
  end

  describe 'POST #create' do
    subject { post account_payouts_url(@account.id) }
    before do
      @user = user_create
      stripe_test_bank = create(:bank)
      create(:branch, bank: stripe_test_bank)
    end
    context 'as a signed in user' do
      before do
        sign_in @user
      end
      context 'successfully' do
        before do
          @account = create(:stripe_account, user: @user, acct_id: valid_stripe_acct_id, ext_acct_id: valid_ext_acct_id)
          allow(StripePayout).to receive(:create_stripe_payout).and_return([true, { 'id' => valid_payout_id, 'amount' => '100' }])
        end
        it 'displays payout result' do
          subject
          expect(response).to have_http_status('200')
          expect(response.body).to include '出金完了'
          expect(flash[:notice]).to include '出金を承りました。'
        end
      end
      context 'if current user is not account owner' do
        before do
          @another_user = create(:user)
          @account = create(:stripe_account, user: @another_user, acct_id: valid_stripe_acct_id2)
        end
        it 'redirects to current user page' do
          subject
          expect(response).to redirect_to user_url(@user.id)
          expect(flash[:alert]).to include '権限がありません。'
          expect(response).to have_http_status('302')
        end
      end
      context 'if bank info is not found' do
        before do
          @account = create(:stripe_account, user: @user, acct_id: valid_stripe_acct_id, ext_acct_id: valid_ext_acct_id)
          allow_any_instance_of(StripeAccount).to receive(:get_ext_account).and_return([false, 'some error message'])
        end
        it 'redirects to current user page' do
          subject
          expect(response).to redirect_to user_url(@user.id)
          expect(flash[:alert]).to include '振込先口座情報が取得できませんでした。'
          expect(response).to have_http_status('302')
        end
      end
      context 'if Stripe create (API) returns error' do
        before do
          @account = create(:stripe_account, user: @user, acct_id: valid_stripe_acct_id, ext_acct_id: valid_ext_acct_id)
          allow(StripePayout).to receive(:create_stripe_payout).and_return([false, 'some error message'])
        end
        it 'redirects to payout#new' do
          subject
          expect(response).to redirect_to new_account_payout_url(@account.id)
          expect(flash[:alert]).to include '出金処理は中断されました。管理者にお問い合わせ下さい。'
          expect(response).to have_http_status('302')
        end
      end
      context 'if Stripe create (Active Record) fails' do
        before do
          @account = create(:stripe_account, user: @user, acct_id: valid_stripe_acct_id, ext_acct_id: valid_ext_acct_id)
          allow(StripePayout).to receive(:create_stripe_payout).and_return([true, { 'id' => valid_payout_id }])
          allow_any_instance_of(StripePayout).to receive(:save).and_return(false)
        end
        it 'redirects to payout#new' do
          subject
          expect(response).to redirect_to new_account_payout_url(@account.id)
          expect(flash[:alert]).to include '出金処理が中断されました。管理者にお問い合わせ下さい。'
          expect(response).to have_http_status('302')
        end
      end
    end
    context 'as a guest' do
      before do
        @account = create(:stripe_account, user: @user, acct_id: valid_stripe_acct_id, ext_acct_id: valid_ext_acct_id)
      end
      it 'redirects to the sign-in page' do
        subject
        expect(response).to redirect_to new_user_session_url
        expect(response).to have_http_status('302')
      end
    end
  end
end
