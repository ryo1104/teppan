class FollowersController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    if @user.follows.find_by(follower_id: current_user.id).present?
      redirect_to user_path(params[:user_id]), alert: 'すでにこのユーザーをフォローしています。' and return
    else
      Follow.create!(create_params)
      end

    @user.reload
    @followed_users = @user.followed_users
  rescue StandardError => e
    ErrorUtility.log_and_notify e
    redirect_to user_path(params[:user_id]), alert: e.message and return
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
  rescue StandardError => e
    ErrorUtility.log_and_notify e
    redirect_to user_path(params[:user_id]), alert: e.message and return
  end

  def index
    @user = User.find(params[:user_id])
    @direction = 'フォロワー'
    @follow_list = @user.followed_users
  end

  private

  def create_params
    params.permit(:user_id).merge(follower_id: current_user.id)
  end

  def delete_params
    params.permit(:user_id, :id)
  end
end
