class FollowingsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @direction = 'フォロー中'
    @follow_list = @user.following_users
  end
end
