require 'rails_helper'

RSpec.describe ViolationsController, type: :request do
  describe 'GET #new' do
    context 'as a signed in user' do
      before do
        @violater = create(:user)
        @user = create(:user)
        sign_in @user
      end
      it 'returns a 200 status code' do
        get new_user_violation_url(@violater.id)
        expect(response).to have_http_status('200')
      end
    end
    context 'as a guest' do
      before do
        @violater = create(:user)
      end
      it 'redirects to the sign-in page' do
        get new_user_violation_url(@violater.id)
        expect(response).to redirect_to new_user_session_url
      end
      it 'returns a 302 status code', type: :doing do
        get new_user_violation_url(@violater.id)
        expect(response).to have_http_status('302')
      end
    end
  end

  describe 'POST #create' do
    context 'as a signed in user' do
      before do
        @user = create(:user)
        sign_in @user
        @violater = create(:user)
      end
      it 'creates a violation' do
        expect do
          post user_violations_url(@violater.id), params: { violation: { text: '', block: 1 } }
        end.
          to change(Violation, :count).by(1)
      end
      it 'deletes follows by reporter when exists' do
        create(:follow, followed: @violater, follower: @user)
        expect do
          post user_violations_url(@violater.id), params: { violation: { text: '', block: 1 } }
        end.
          to change(Follow, :count).by(-1)
      end
      it 'redirects to violater user page' do
        post user_violations_url(@violater.id), params: { violation: { text: '', block: 1 } }
        expect(response).to redirect_to user_path(@violater.id)
      end
      it 'returns a 302 status code' do
        post user_violations_url(@violater.id), params: { violation: { text: '', block: 1 } }
        expect(response).to have_http_status('302')
      end

      context 'when saving record fails' do
        before do
          create(:violation, user: @violater, reporter_id: @user.id)
        end
        it 'displays new template' do
          post user_violations_url(@violater.id), params: { violation: { text: '', block: 1 } }
          expect(response.body).to include '報告する'
        end
        it 'returns a 200 status code' do
          post user_violations_url(@violater.id), params: { violation: { text: '', block: 1 } }
          expect(response).to have_http_status('200')
        end
      end
    end
  end
end
