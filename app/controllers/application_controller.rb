class ApplicationController < ActionController::Base
  include ErrorUtils
  before_action :authenticate_user!
  
  def after_sign_in_path_for(resource)
    if current_user.nickname.present?
      root_path
    else
      user_path(current_user.id) # 主に初回ログイン時ニックネーム登録ページへ遷移
    end
  end

end
