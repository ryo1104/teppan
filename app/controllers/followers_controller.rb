class FollowersController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @followers = @user.followed_users
  end

  def create
    @user = User.find(params[:user_id])
    if @user.follows.find_by(follower_id: current_user.id).present?
      redirect_to user_path(params[:user_id]), alert: 'すでにこのユーザーをフォローしています。' and return
    else
      Follow.create!(create_params)
    end
    @user.reload
    @followed_users = @user.followed_users
  end

  def destroy
    @user = User.find(params[:user_id])
    @follow = @user.follows.find_by(follower_id: delete_params[:id])
    if @follow.present?
      @follow.destroy!
      @user.reload
      @followed_users = @user.followed_users
    else
      redirect_to user_path(params[:user_id]), alert: 'このユーザーのフォローが存在しません。' and return
    end
  end

  private

  def create_params
    params.permit(:user_id).merge(follower_id: current_user.id)
  end

  def delete_params
    params.permit(:user_id, :id)
  end
end
