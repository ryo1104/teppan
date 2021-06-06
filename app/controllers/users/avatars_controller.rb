# frozen_string_literal: true

class Users::AvatarsController < ApplicationController
  def destroy
    @user = User.find(params[:user_id])
    if valid_data
      object = S3_BUCKET.object(@user.avatar_img_url.split('amazonaws.com/')[1])
      if object.delete
        @user.avatar_img_url = nil
        @user.save
      else
        Rails.logger.error "S3 object delete failed. User ID : #{@user.id}"
      end
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
        @message = "user.avatar_img_url is blank. User ID : #{@user.id}"
        false
      end
    else
      @message = I18n.t('controller.general.no_access')
      false
    end
  end
end
