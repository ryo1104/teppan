require 'rails_helper'

RSpec.describe Business::IdcardsController, type: :request do
  let(:user_create)       { create(:user) }
  let(:account_create)    { create(:stripe_account) }

  describe 'GET #new' do
    subject { get new_account_idcard_url(@account.id) }

    context 'as a signed in user' do
      before do
        @user = user_create
        sign_in @user
        @account = account_create
      end
      it 'returns a 200 status code' do
        subject
        expect(response).to have_http_status('200')
      end
      it 'displays file upload screen' do
        subject
        expect(response.body).to include '身分証明証のコピー'
      end
    end

    context 'as a guest' do
      before do
        @account = account_create
      end
      it 'returns a 302 status code' do
        subject
        expect(response).to have_http_status('302')
      end
      it 'redirects to the sign-in page' do
        subject
        expect(response).to redirect_to new_user_session_url
      end
    end
  end
end
