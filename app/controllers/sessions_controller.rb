class SessionsController < ApplicationController
  
  def create
    if auth_params.present?

      @auth_ret = Authorization.find_from_auth(auth_params)
      @auth_ret = Authorization.create_from_auth(auth_params) unless @auth_ret[0]

      if @auth_ret[0]
        @the_user = @auth_ret[1].user
        sign_in_and_redirect @the_user, :event => :authentication
      else
        Rails.logger.error "Authorization.create_from_auth returned false : #{@auth_ret[1]}"
        redirect_to new_user_session_path, alert: "ユーザー認証に失敗しました。" and return
      end

    else
      Rails.logger.error "request.env[omniauth.auth] does not exist"
      redirect_to new_user_session_path, alert: "ユーザー認証に失敗しました。" and return
    end
  end
  
  def failure
    redirect_to new_user_session_path, alert: "外部サービスへの接続に失敗しました。" and return
  end
  
  private
  
  def auth_params
    request.env["omniauth.auth"]
  end

end
