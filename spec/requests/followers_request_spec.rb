require 'rails_helper'

RSpec.describe FollowersController, type: :request do
  describe 'GET #index' do
    subject { get user_followers_url(@target_user.id) }

    context 'as a signed in user' do
      before do
        @my_user = create(:user)
        sign_in @my_user
        @target_user = create(:user)
        @another_user = create(:user)
        create(:follow, followed: @target_user, follower: @my_user)
        create(:follow, followed: @target_user, follower: @another_user)
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

  describe 'POST #create' do
    subject { post user_followers_url(@target_user.id), xhr: true }

    context 'as a signed in user' do
      before do
        @target_user = create(:user)
        @follower = create(:user, nickname: 'follower')
        sign_in @follower
      end
      it 'creates a follow' do
        expect do
          subject
        end.
          to change(Follow, :count).by(1)
      end
      it 'returns a 200 status code' do
        subject
        expect(response).to have_http_status('200')
      end
      context 'when follower is already following target user' do
        before do
          create(:follow, followed: @target_user, follower: @follower)
        end
        it 'redirects to user#show ' do
          subject
          expect(response).to redirect_to user_path(@target_user.id)
        end
      end
    end
    context 'as a guest' do
      before do
        @target_user = create(:user)
      end
      it 'returns a 401 status code' do
        subject
        expect(response).to have_http_status('401')
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete user_follower_url(@target_user.id, @follower.id), xhr: true }

    context 'as a signed in user' do
      before do
        @target_user = create(:user)
        @follower = create(:user, nickname: 'follower')
        sign_in @follower
      end
      context 'when follow exists' do
        before do
          create(:follow, followed: @target_user, follower: @follower)
        end
        it 'deletes follow' do
          expect do
            subject
          end.
            to change(Follow, :count).by(-1)
        end
        it 'returns a 200 status code' do
          subject
          expect(response).to have_http_status('200')
        end
      end
      context 'when follow does not exist' do
        it 'redirects to user#show' do
          subject
          expect(response).to redirect_to user_path(@target_user.id)
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
        @follower = create(:user, nickname: 'follower')
      end
      it 'returns a 401 status code' do
        subject
        expect(response).to have_http_status('401')
      end
    end
  end
end
