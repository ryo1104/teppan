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
    provider_name = provider_jp(provider.to_s)
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
  def passthru
    super
  end

  # GET|POST /users/auth/twitter/callback
  def failure
    super
  end

  protected

  # The path used when OmniAuth fails
  def after_omniauth_failure_path_for(scope)
    super(scope)
  end

  def provider_jp(str)
    case str
    when 'yahoojp'
      'Yahoo Japan'
    when 'twitter'
      'Twitter'
    when 'google_oauth2'
      'Google'
    end
  end
end
