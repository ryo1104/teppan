class SessionsController < ApplicationController
  
  def create
    begin
      if auth_params.present?
        if @auth = Authorization.find_from_auth(auth_params)
          @auth_ret = [true, @auth]
        else
          @auth_ret = Authorization.create_from_auth(auth_params)
        end
        if @auth_ret[0]
          @user = @auth_ret[1].user
          sign_in_and_redirect @user, :event => :authentication
        else
          Rails.logger.error "Authorization.create_from_auth returned false : #{@auth_ret[1]}"
          redirect_to new_user_session_path, alert: "ユーザー認証に失敗しました。" and return
        end
      else
        Rails.logger.error "request.env[omniauth.auth] does not exist"
        redirect_to new_user_session_path, alert: "ユーザー認証に失敗しました。" and return
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to root_path, alert: e.message and return
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
