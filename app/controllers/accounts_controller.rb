class AccountsController < ApplicationController
  before_action :authenticate_user!
  include StripeUtils
  
  def new
    begin
      if qualified
        @user = User.find(params[:user_id])
        if @user.account.present?
          redirect_to edit_account_path(@user.account.id), alert: "すでに出金用アカウントが存在します。" and return
        end
      else
        redirect_to user_path(current_user.id), alert: "アカウントを作成する条件を満たしていません。" and return
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to user_path(params[:user_id]), alert: "エラーが発生しました。" and return
    end
  end
  
  def confirm
    begin
      if qualified
        @user = User.find(params[:user_id])
        @account = new_account_params
      else
        redirect_to user_path(current_user.id), alert: "アカウントを作成する条件を満たしていません。" and return
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to user_path(params[:user_id]), alert: "エラーが発生しました。" and return
    end
  end
  
  def create
    begin
      if qualified
        user = User.find(params[:user_id])
        if params[:back]
          
        else
          stripe_result = Account.create_stripe_account(new_account_params)
          if stripe_result[0]
            account = Account.create!(user_id: user.id, stripe_acct_id: stripe_result[1]["id"], stripe_status: stripe_result[1]["personal_info"]["verification"]["status"] )
            redirect_to account_path(account.id), notice: "出金用アカウントが作成されました。" and return
          else
            Rails.logger.error "create_stripe_account returned false : #{stripe_result[1]}"
            redirect_to user_path(user.id), alert: "出金用アカウントが作成できませんでした。" and return
          end
        end
      else
        Rails.logger.info "User ID #{current_user.id} is not qualified to create a sellers account."
        redirect_to user_path(current_user.id), alert: "アカウントを作成するユーザー条件を満たしていません。" and return
      end
    rescue Stripe::PermissionError => e
      ErrorUtility.log_and_notify e
      redirect_to user_path(current_user.id), alert: "アカウント情報の取得に失敗しました。" and return
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to new_user_account_path(params[:user_id]), alert: "システムエラーにより出金用アカウントが作成できませんでした。しばらく時間をおいて再度お試しください。" and return
    end
  end
  
  def show
    begin
      @account = Account.includes(:externalaccount).find(params[:id])
      redirect_to user_path(current_user.id), alert: "アクセス権限がありません。" and return unless @account.user_id == current_user.id
      
      stripe_result_acct = @account.get_stripe_account
      if stripe_result_acct[0]
        @account_info = stripe_result_acct[1]
      else
        Rails.logger.error "get_stripe_account returned false : #{stripe_result_acct[1]}"
        redirect_to user_path(current_user.id), alert: "アカウント情報を取得できませんでした。" and return
      end
      
      if @account_info["personal_info"]["verification"]["status"].present?
        latest_stripe_status = @account_info["personal_info"]["verification"]["status"]
        if latest_stripe_status != @account.stripe_status
          if @account.update!(stripe_status: latest_stripe_status)
            @account.reload
          end
        end
      end
      
      stripe_result_balance = @account.get_stripe_balance
      if stripe_result_balance[0]
        @balance_info = stripe_result_balance[1]
      else
        Rails.logger.error "get_stripe_balance returned false : #{stripe_result_balance[1]}"
        redirect_to user_path(current_user.id), alert: "残高情報を取得できませんでした。" and return
      end
      
    rescue Stripe::PermissionError => e
      ErrorUtility.log_and_notify e
      redirect_to user_path(current_user.id), alert: "アカウント情報の取得に失敗しました。" and return
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to user_path(current_user.id), alert: "システムエラーにより出金用アカウントが作成できませんでした。しばらく時間をおいて再度お試しください。" and return
    end
  end
  
  def edit
    begin
      @account = Account.find(params[:id])
      redirect_to user_path(current_user.id), alert: "アクセス権限がありません。" and return unless @account.user_id == current_user.id
      # @stripe_account = account.get_stripe_account
      # @account_info = Account.extract_account_info(@stripe_account)
      stripe_result_acct = @account.get_stripe_account
      if stripe_result_acct[0]
        @account_info = stripe_result_acct[1]
      else
        Rails.logger.error "get_stripe_account returned false : #{stripe_result_acct[1]}"
        redirect_to user_path(current_user.id), alert: "アカウント情報を取得できませんでした。" and return
      end
    rescue Stripe::PermissionError => e
      ErrorUtility.log_and_notify e
      redirect_to user_path(current_user.id), alert: "口座情報にアクセス権限がありません。" and return
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to user_path(current_user.id), alert: "エラーが発生しました。" and return
    end    
  end
  
  def update
    begin
      @account = Account.find(params[:id])
      redirect_to user_path(current_user.id), alert: "アクセス権限がありません。" and return unless @account.user_id == current_user.id

      stripe_result_acct = @account.update_stripe_account(account_params)
      if stripe_result_acct[0]
        @account_info = stripe_result_acct[1]
        @account.update!(stripe_status: @account_info["personal_info"]["verification"]["status"])
        redirect_to account_path(@account.id), notice: "アカウント情報が更新されました。" and return
      else
        Rails.logger.error "update_stripe_account returned false : #{stripe_result_acct[1]}"
        redirect_to edit_account_path(@account.id), alert: "アカウント情報を更新できませんでした。" and return
      end
    rescue Stripe::PermissionError => e
      ErrorUtility.log_and_notify e
      redirect_to user_path(current_user.id), alert: "口座情報にアクセス権限がありません。" and return
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to edit_account_path(params[:id]), alert: "エラーが発生しました。" and return
    end
  end
  
  def destroy
    begin
      @account = Account.find(params[:id])
      redirect_to user_path(current_user.id), alert: "アクセス権限がありません。" and return unless @account.user_id == current_user.id
      if @account.zero_balance
        stripe_result_acct = @account.delete_stripe_account
        if stripe_result_acct[0]
          @delete_result = stripe_result_acct[1]
          @account.destroy!
          @message = "出金用アカウントを削除しました。"
        else
          Rails.logger.error "delete_stripe_account returned false : #{stripe_result_acct[1]}"
          redirect_to account_path(@account.id), alert: "出金用アカウントを削除できませんでした。" and return
        end
      else
        redirect_to account_path(@account.id), alert: "アカウントに残高が残っています。" and return
      end
    rescue Stripe::PermissionError => e
      ErrorUtility.log_and_notify e
      redirect_to user_path(current_user.id), alert: "口座情報にアクセス権限がありません。" and return
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to account_path(params[:id]), alert: "エラーが発生しました。" and return
    end
  end

  private

  def qualified
    if current_user.id == params[:user_id].to_i && current_user.premium_user[0]
      return true
    else
      return false
    end
  end
  
  def new_account_params
    ac_params = account_params
    ac_params.merge!(:type => "custom")
    ac_params.merge!(:country => "JP")
    return ac_params
  end
  
  def account_params
    filtered_params = params.permit(:user_id, :last_name_kanji, :last_name_kana, :first_name_kanji, :first_name_kana, 
                                    :postal_code, :state, :city, :town, :kanji_line1, :kanji_line2, :kana_line1, :kana_line2, 
                                    :gender, :birthdate, :phone, :email, :user_agreement)
    ac_params = {
      business_type: "individual",
      individual:{
        last_name:        filtered_params[:last_name_kanji].present? ? filtered_params[:last_name_kanji] : nil,
        last_name_kanji:  filtered_params[:last_name_kanji].present? ? filtered_params[:last_name_kanji] : nil,
        last_name_kana:   filtered_params[:last_name_kana].present? ? filtered_params[:last_name_kana] : nil,
        first_name:       filtered_params[:first_name_kanji].present? ? filtered_params[:first_name_kanji] : nil,
        first_name_kanji: filtered_params[:first_name_kanji].present? ? filtered_params[:first_name_kanji] : nil,
        first_name_kana:  filtered_params[:first_name_kana].present? ? filtered_params[:first_name_kana] : nil,
        gender:           filtered_params[:gender].present? ? filtered_params[:gender] : nil,
        dob:              (filtered_params["birthdate(1i)"].present? && filtered_params["birthdate(2i)"].present? && filtered_params["birthdate(3i)"].present?) ? {year: filtered_params["birthdate(1i)"], month: filtered_params["birthdate(2i)"], day: filtered_params["birthdate(3i)"],} : nil,
        address_kanji:{
          postal_code:    filtered_params[:postal_code].present? ? filtered_params[:postal_code] : nil,
          state:          (filtered_params[:state].present? && filtered_params[:postal_code].present?) ? filtered_params[:state] : nil,
          city:           (filtered_params[:city].present? && filtered_params[:postal_code].present?) ? filtered_params[:city] : nil,
          town:           (filtered_params[:town].present? && filtered_params[:postal_code].present?) ? filtered_params[:town] : nil,
          line1:          (filtered_params[:kanji_line1].present? && filtered_params[:postal_code].present?) ? filtered_params[:kanji_line1] : nil,
          line2:          (filtered_params[:kanji_line2].present? && filtered_params[:postal_code].present?) ? filtered_params[:kanji_line2] : nil,
        },
        address_kana:{
          line1:          (filtered_params[:kana_line1].present? && filtered_params[:postal_code].present?) ? hankaku(filtered_params[:kana_line1]) : nil,
          line2:          (filtered_params[:kana_line2].present? && filtered_params[:postal_code].present?) ? hankaku(filtered_params[:kana_line2]) : nil,
        },
        phone:            filtered_params[:phone].present? ? filtered_params[:phone] : nil,
        email:            filtered_params[:email].present? ? filtered_params[:email] : nil,
      },
    }
    if filtered_params[:user_agreement] == "true"
      user_agree_date = Time.parse(Time.zone.now.to_s).to_i
      user_ip = request.remote_ip
      ac_params.merge!(
        tos_acceptance: {
          date: user_agree_date,
          ip: user_ip   
        })
    end
    return ac_params
  end
  
  def hankaku(str)
    if str == nil
      return nil
    else
      return NKF.nkf('-w -Z4', str)
    end
  end
  
end
