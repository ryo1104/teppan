# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    if unregistered_user
      redirect_to new_user_registration_path, alert: 'メールアドレスまたはパスワードが無効です。' and return
    else
      super
    end
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    if user_signed_in? && resource.class.name == 'User'
      if resource.id == current_user.id
        user = User.find(resource.id)
        if user.can_unregister[0]
          if user.update(unregistered: true)
            sign_out(resource)
          else
            redirect_to user_path(current_user.id), alert: '退会処理に失敗しました。' and return
          end
        else
          redirect_to user_path(current_user.id), alert: '必要なデータを削除して下さい。' and return
        end
      else
        redirect_to user_path(current_user.id), alert: '権限がありません。' and return
      end
    else
      redirect_to root_path and return
    end
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    edit_user_path(resource.id) # Nicknameの登録を促すためにUser#editにredirectさせる
  end

  def after_update_path_for(resource)
    user_path(resource.id)
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private

  def unregistered_user
    if params['user']['email'].present?
      user = User.find_by(email: params['user']['email'])
      if user.present?
        return true if user.unregistered
      end
    end
    false
  end
end
