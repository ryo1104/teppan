# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    if get_user
      if registered_user
        super
      else
        redirect_to new_user_session_path, alert: 'メールアドレスまたはパスワードが無効です。' and return
      end
    else
      redirect_to new_user_session_path, alert: 'メールアドレスまたはパスワードが無効です。' and return
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def get_user
    if params['user']['email'].present?
      @user = User.find_by(email: params['user']['email'])
      true
    else
      false
    end
  end

  def registered_user
    if @user.unregistered
      false
    else
      true
    end
  end
  
end
