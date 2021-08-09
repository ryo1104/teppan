# frozen_string_literal: true

class ViolationsController < ApplicationController
  before_action :unfollow, only: %i[create]

  def new
    @user = User.find(params[:user_id])
    @violation = Violation.new
  end

  def create
    @violation = Violation.new(create_params)
    if @violation.save
      redirect_to user_path(params[:user_id]), notice: "#{User.find(params[:user_id]).nickname}さんに対する違反報告を受け付けました。" and return
    else
      @user = User.find(params[:user_id])
      render :new and return
    end
  end

  private

  def create_params
    params.require(:violation).permit(:text, :block).merge(user_id: params[:user_id], reporter_id: current_user.id)
  end

  def unfollow
    target_usr = User.find(params[:user_id])
    follow = Follow.find_by(followed: target_usr, follower: current_user)
    follow.destroy if follow.present?
  end
end
