require 'rails_helper'

RSpec.describe 'Policies', type: :request do
  describe 'GET #show' do
    subject { get policy_url }

    context 'as a signed in user' do
      before do
        @user = create(:user)
        sign_in @user
      end
      it 'displays document' do
        subject
        expect(response.body).to include '利用者情報の取扱いについて'
      end
      it 'returns a 200 status code' do
        subject
        expect(response).to have_http_status('200')
      end
    end

    context 'as a guest' do
      it 'displays document' do
        subject
        expect(response.body).to include '利用者情報の取扱いについて'
      end
      it 'returns a 200 status code' do
        subject
        expect(response).to have_http_status('200')
      end
    end
  end
end
