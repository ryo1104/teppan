class FollowingsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @followings = @user.following_users
  end
end
