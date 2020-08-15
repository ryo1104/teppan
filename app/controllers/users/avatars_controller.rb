class Users::AvatarsController < ApplicationController
  def destroy
    @user = User.find(params[:user_id])
    if @user.id == current_user.id
      @user.image.purge if @user.image.attached?
    end
    redirect_to edit_user_path(@user.id) and return
  end
end
