require 'rails_helper'

RSpec.describe 'Userterms', type: :request do
  describe 'GET #show' do
    subject { get userterm_url }

    context 'as a signed in user' do
      before do
        @user = create(:user)
        sign_in @user
      end
      it 'displays document' do
        subject
        expect(response.body).to include 'Teppan利用規約'
      end
      it 'returns a 200 status code' do
        subject
        expect(response).to have_http_status('200')
      end
    end

    context 'as a guest' do
      it 'displays document' do
        subject
        expect(response.body).to include 'Teppan利用規約'
      end
      it 'returns a 200 status code' do
        subject
        expect(response).to have_http_status('200')
      end
    end
  end
end
