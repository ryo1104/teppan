# frozen_string_literal: true

class Users::AvatarsController < ApplicationController
  def destroy
    @user = User.find(params[:user_id])
    if valid_data
      @user.avatar_img_url = nil
      @user.save!
      redirect_to edit_user_path(@user.id) and return
    else
      redirect_to user_path(current_user.id), notice: @message and return
    end
  end

  private

  def valid_data
    if @user.id == current_user.id
      if @user.avatar_img_url.present?
        true
      else
        @message = I18n.t('controller.user.avatar.blank')
        false
      end
    else
      @message = I18n.t('controller.general.no_access')
      false
    end
  end
end
