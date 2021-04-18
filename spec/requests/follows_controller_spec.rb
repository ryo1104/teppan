require 'rails_helper'

RSpec.describe FollowsController, type: :request do
  describe 'POST #create' do
    context 'as a signed in user' do
      before do
        @target_user = FactoryBot.create(:user)
        @follower = FactoryBot.create(:user, nickname: 'follower')
        sign_in @follower
      end
      it 'populates @user' do
        post user_follows_path(@target_user.id), xhr: true
        expect(assigns(:user)).to eq @target_user
      end
      it 'creates a follow' do
        expect do
          post user_follows_path(@target_user.id), xhr: true
        end.to change(Follow, :count).by(1)
      end
      it 'populates @followed_users' # do
      #   @other_follower1 = FactoryBot.create(:user, nickname: "other_follower1")
      #   FactoryBot.create(:follow, user_id: @target_user.id, follower_id: @other_follower1.id)
      #   @other_follower2 = FactoryBot.create(:user, nickname: "other_follower2")
      #   FactoryBot.create(:follow, user_id: @target_user.id, follower_id: @other_follower2.id)
      #   @followers = User.includes(:netas, image_attachment: :blob).where("nickname LIKE ?", "%follower%")

      #   post user_follows_path(@target_user.id), xhr: true
      #   expect(assigns(:followed_users)).to match @followers
      # end
      it 'returns a 200 status code' do
        post user_follows_path(@target_user.id), xhr: true
        expect(response).to have_http_status('200')
      end
      it 'redirects to user#show when follower is already following target user' do
        FactoryBot.create(:follow, user_id: @target_user.id, follower_id: @follower.id)
        post user_follows_path(@target_user.id), xhr: true
        expect(response).to redirect_to user_path(@target_user.id)
      end
    end
    context 'as a guest' do
      before do
        @target_user = FactoryBot.create(:user)
      end
      it 'redirects to user sign-in page' # do
      #   post user_follows_path(@target_user.id), xhr: true
      #   expect(response).to redirect_to "/users/sign_in"
      # end
      it 'returns a 401 status code' do
        post user_follows_path(@target_user.id), xhr: true
        expect(response).to have_http_status('401')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as a signed in user' do
      before do
        @target_user = FactoryBot.create(:user)
        @follower = FactoryBot.create(:user, nickname: 'follower')
        sign_in @follower
      end
      context 'when follow exists' do
        before do
          @follow = FactoryBot.create(:follow, user_id: @target_user.id, follower_id: @follower.id)
        end
        it 'populates @user' do
          delete user_follow_path(@target_user.id, @follower.id), xhr: true
          expect(assigns(:user)).to eq @target_user
        end
        it 'populates @follow' do
          delete user_follow_path(@target_user.id, @follower.id), xhr: true
          expect(assigns(:follow)).to eq @follow
        end
        it 'deletes follow' do
          expect do
            delete user_follow_path(@target_user.id, @follower.id), xhr: true
          end.to change(Follow, :count).by(-1)
        end
        it 'populates @followed_users'
        it 'returns a 200 status code' do
          delete user_follow_path(@target_user.id, @follower.id), xhr: true
          expect(response).to have_http_status('200')
        end
      end
      context 'when follow does not exist' do
        it 'redirects to user#show' do
          delete user_follow_path(@target_user.id, @follower.id), xhr: true
          expect(response).to redirect_to user_path(@target_user.id)
        end
        it 'returns a 302 status code' do
          delete user_follow_path(@target_user.id, @follower.id), xhr: true
          expect(response).to have_http_status('302')
        end
      end
    end
    context 'as a guest' do
      before do
        @target_user = FactoryBot.create(:user)
        @follower = FactoryBot.create(:user, nickname: 'follower')
      end
      it 'redirects to user sign-in page' # do
      #   post user_follow_path(@target_user.id), xhr: true
      #   expect(response).to redirect_to "/users/sign_in"
      # end
      it 'returns a 401 status code' do
        delete user_follow_path(@target_user.id, @follower.id), xhr: true
        expect(response).to have_http_status('401')
      end
    end
  end
  describe 'GET #index' do
    context 'as a signed in user' do
      before do
        @target_user = FactoryBot.create(:user)
        @follows = create_list(:follow, 3, user: @target_user)
        sign_in @target_user
      end
      context 'when searching for following users' do
        it 'populates @direction as フォロー中' do
          get "/users/#{@target_user.id}/follows/following"
          expect(assigns(:direction)).to eq 'フォロー中'
        end
        it 'populates @follow_list' # do
        # puts "@follows = "
        # puts @follows.inspect
        # @users = User.all
        # puts "@users = "
        # puts @users.inspect
        # @following_users = User.last(3)
        # get "/users/#{@target_user.id}/follows/following"
        # expect(assigns(:follow_list)).to match(@users)
        # end
        it 'returns a 200 status code' do
          get "/users/#{@target_user.id}/follows/following"
          expect(response).to have_http_status('200')
        end
      end
      context 'when searching for followed users' do
        it 'populates @direction as フォロワー' do
          get "/users/#{@target_user.id}/follows/followed"
          expect(assigns(:direction)).to eq 'フォロワー'
        end
        it 'populates @follow_list'
        it 'returns a 200 status code' do
          get "/users/#{@target_user.id}/follows/followed"
          expect(response).to have_http_status('200')
        end
      end
    end
  end
end
