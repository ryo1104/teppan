# frozen_string_literal: true

class FollowersController < ApplicationController
  def index
    @user = User.find(params[:user_id])
  end

  def create
    @user = User.find(params[:user_id])
    if @user.followed_by(current_user.id)
      redirect_to user_path(params[:user_id]), alert: I18n.t('controller.follower.duplicate') and return
    else
      Follow.create!(followed_id: create_params[:user_id], follower_id: current_user.id)
    end

    @user.reload
  end

  def destroy
    @user = User.find(params[:user_id])
    @follow = Follow.find_by(followed_id: delete_params[:user_id], follower_id: delete_params[:id])
    if @follow.present?
      @follow.destroy!
      @user.reload
    else
      redirect_to user_path(params[:user_id]), alert: I18n.t('controller.follower.blank') and return
    end
  end

  private

  def create_params
    params.permit(:user_id)
  end

  def delete_params
    params.permit(:user_id, :id)
  end
end
