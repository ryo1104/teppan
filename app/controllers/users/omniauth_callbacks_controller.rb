# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    callback_from(:google_oauth2)
  end

  def twitter
    callback_from(:twitter)
  end

  def yahoojp
    callback_from(:yahoojp)
  end

  def callback_from(provider)
    provider_name = I18n.t("controller.user.omniauth_callbacks.#{provider}")
    if provider_name.present?
      @user = User.find_or_create_for_oauth(request.env['omniauth.auth'])
      if @user.persisted? && @user.unregistered == false
        flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: provider_name)
        sign_in_and_redirect @user
      else
        redirect_to new_user_registration_url
      end
    else
      redirect_to new_user_registration_url
    end
  end

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
