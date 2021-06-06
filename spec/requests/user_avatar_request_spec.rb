require 'rails_helper'

RSpec.describe Users::AvatarsController, type: :request do
  describe 'DELETE #destroy' do
    subject { delete user_avatar_url(@target_user.id) }

    context 'as a signed in user' do
      before do
        @user = create(:user)
        sign_in @user
      end
      context 'if current_user is owner' do
        before do
          @target_user = @user
        end
        context 'if avatar_img_url field is present' do
          before do
            @target_user.update(avatar_img_url: 'https://amazonaws.com/avatar_images/dummy_image.jpg')
          end
          context 'when S3 object delete is successful' do
            it 'header_img_url field is reset to nil' do
              subject
              @target_user.reload
              expect(@target_user.avatar_img_url).to eq nil
            end
            it 'redirects to topic edit' do
              subject
              expect(response).to redirect_to edit_user_url(@target_user.id)
            end
            it 'returns a 302 status code' do
              subject
              expect(response).to have_http_status('302')
            end
          end
          context 'when S3 object delete fails' do
            it 'does not reset avatar_img_url field'
            it 'logs error message'
          end
        end
        context 'if avatar_img_url field is blank' do
          it 'redirects to topic edit' do
            subject
            expect(response).to redirect_to user_url(@user.id)
          end
          it 'returns a 302 status code' do
            subject
            expect(response).to have_http_status('302')
          end
        end
      end
      context 'if current_user is not owner' do
        before do
          @target_user = create(:user)
        end
        it 'redirects to my user page' do
          subject
          expect(response).to redirect_to user_url(@user.id)
        end
        it 'returns a 302 status code' do
          subject
          expect(response).to have_http_status('302')
        end
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
      it 'redirects to user sign-in page' do
        subject
        expect(response).to redirect_to new_user_session_url
      end
    end
  end
end
