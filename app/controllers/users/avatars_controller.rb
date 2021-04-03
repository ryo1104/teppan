class Users::AvatarsController < ApplicationController
  def destroy
    @user = User.find(params[:user_id])
    if @user.id == current_user.id
      if @user.avatar_img_url.present?
        object = S3_BUCKET.object(@user.avatar_img_url.split('amazonaws.com/')[1])
        if object.delete
          @user.avatar_img_url = nil
          @user.save
        end
      end
    end
    redirect_to edit_user_path(@user.id) and return
  end
end
