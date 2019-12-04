class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    begin
      @user = User.find(params[:user_id])
      unless @user.follows.find_by(follower_id: current_user.id).present?
        Follow.create!(create_params)
      else
        redirect_to user_path(params[:user_id]), alert: "すでにこのユーザーをフォローしています。" and return
      end
      @user.reload
      @followed_users = @user.followed_users
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to user_path(params[:user_id]), alert: e.message and return
    end
  end
  
  def destroy
    begin
      @user = User.find(params[:user_id])
      @follow = @user.follows.find_by(follower_id: delete_params[:id])
      if @follow.present?
        @follow.destroy!
        @user.reload
        @followed_users = @user.followed_users
      else
        redirect_to user_path(params[:user_id]), alert: "このユーザーのフォローが存在しません。" and return
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to user_path(params[:user_id]), alert: e.message and return
    end    
  end
  
  def index
    begin
      @user = User.find(params[:user_id])
      @follow_direction = params[:direction]
      
      if @follow_direction == "following"
        @direction = "フォロー中"
        @follow_list = @user.following_users
      elsif @follow_direction == "followed"
        @direction = "フォロワー"
        @follow_list = @user.followed_users
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to user_path(params[:user_id]), alert: e.message and return
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
