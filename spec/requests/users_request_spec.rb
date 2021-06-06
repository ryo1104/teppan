require 'rails_helper'

RSpec.describe Users::AvatarsController, type: :request do
  describe 'GET #show', type: :request do
    subject { get user_url(@user.id) }

    context 'as a signed in user' do
      before do
        @user = create(:user)
        sign_in @user
      end
      context 'as a owner' do
        context 'but nickname is blank' do
          before do
            @user.update!(nickname: nil)
          end
          it 'redirects to edit user page' do
            subject
            expect(response).to redirect_to edit_user_url(@user.id)
          end
          it 'returns a 302 status code' do
            subject
            expect(response).to have_http_status('302')
          end
        end
        context 'and nickname is present' do
          before do
            @user.update!(nickname: 'ひろき')
          end
          it 'displays info permissioned only for owner'
          it 'returns a 200 status code' do
            subject
            expect(response).to have_http_status('200')
          end
        end
      end
      context 'as a non-owner'
    end

    context 'as a guest' do
      before do
        @user = create(:user)
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
