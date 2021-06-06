require 'rails_helper'

RSpec.describe FollowingsController, type: :request do
  describe 'GET #index' do
    subject { get user_followings_url(@target_user.id) }

    context 'as a signed in user' do
      before do
        @my_user = create(:user)
        sign_in @my_user
        @target_user = create(:user)
      end
      it 'returns a 200 status code' do
        subject
        expect(response).to have_http_status('200')
      end
    end

    context 'as a guest' do
      before do
        @target_user = create(:user)
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
