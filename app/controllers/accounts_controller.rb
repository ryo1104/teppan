class AccountsController < ApplicationController
  include StripeUtils
  
  def new
    @user = User.find(params[:user_id])
    if qualified(@user)
      unless @user.account.present?
        @account = Account.new
      else
        redirect_to edit_account_path(@user.account.id), alert: "すでにビジネスアカウントが存在します。" and return
      end
    else
      redirect_to user_path(current_user.id), alert: "ビジネスアカウントを作成するユーザー条件を満たしていません。" and return
    end
  end
  
  def confirm
    @mode = params[:mode]
    if @mode == "new"
      @user = User.find(params[:user_id])
      @account = Account.new(create_params)
    elsif @mode == "edit"
      @account = Account.find(params[:id])
      @account.assign_attributes(update_params)
      @user = @account.user
    end
  end
  
  def create
    begin
      @user = User.find(params[:user_id])
      if qualified(@user)
        @account = Account.new(create_params)
        if params[:back]
          render :new and return
        else
          @account.transaction do
            @account.save!
            @stripe_result = @account.create_stripe_account(request.remote_ip)
          end
          if @stripe_result[0]
            @account.update!(user_id: @user.id, stripe_acct_id: @stripe_result[1]["id"], stripe_status: @stripe_result[1]["personal_info"]["verification"]["status"] )
            redirect_to account_path(@account.id), notice: "出金用アカウントが作成されました。" and return
          else
            Rails.logger.error "create_stripe_account returned false : #{@stripe_result[1]}"
            redirect_to user_path(@user.id), alert: "出金用アカウントが作成できませんでした。" and return
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
      redirect_to new_user_account_path(params[:user_id]), alert: "システムエラーが発生しました。" and return
    end
  end
  
  def edit
    begin
      @account = Account.find(params[:id])
      if @account.user_id == current_user.id
        # @stripe_account = account.get_stripe_account
        # @account_info = Account.extract_account_info(@stripe_account)
        # stripe_result_acct = @account.get_stripe_account
        # if stripe_result_acct[0]
        #   @account_info = stripe_result_acct[1]
        # else
        #   Rails.logger.error "get_stripe_account returned false : #{stripe_result_acct[1]}"
        #   redirect_to user_path(current_user.id), alert: "アカウント情報を取得できませんでした。" and return
        # end
      else
        redirect_to user_path(current_user.id), alert: "アクセス権限がありません。" and return
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
      if params[:back]
        @account.assign_attributes(update_params)
        render :edit and return
      else
        @account.transaction do
          @account.update!(update_params)
          @stripe_result_acct = @account.update_stripe_account(request.remote_ip)
        end
        if @stripe_result_acct[0]
          @account_info = @stripe_result_acct[1]
          @account.update!(stripe_status: @account_info["personal_info"]["verification"]["status"])
          redirect_to account_path(@account.id), notice: "アカウント情報が更新されました。" and return
        else
          Rails.logger.error "update_stripe_account returned false : #{@stripe_result_acct[1]}"
          redirect_to edit_account_path(@account.id), alert: "アカウント情報を更新できませんでした。" and return
        end
      end
    rescue Stripe::PermissionError => e
      ErrorUtility.log_and_notify e
      redirect_to user_path(current_user.id), alert: "口座情報にアクセス権限がありません。" and return
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to edit_account_path(params[:id]), alert: "エラーが発生しました。" and return
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
      redirect_to user_path(current_user.id), alert: "システムエラーが発生しました。しばらく時間をおいて再度お試しください。" and return
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
          if @account.destroy!
            Rails.logger.error "account.destroy succeeded. Account id : #{@account.id}, @delete_result = #{@delete_result}"
            redirect_to user_path(current_user.id), alert: "出金用アカウントを削除しました。" and return
          else
            Rails.logger.error "account.destroy failed. Account id : #{@account.id}"
            redirect_to account_path(@account.id), alert: "出金用アカウントを削除できませんでした。" and return
          end
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

  def qualified(user)
    if current_user.id == user.id && current_user.premium_user[0]
      return true
    else
      return false
    end
  end
  
  def create_params
    params.require(:account).permit(:last_name_kanji, :last_name_kana, :first_name_kanji, :first_name_kana, 
                            :postal_code, :state, :city, :town, :kanji_line1, :kanji_line2, :kana_line1, :kana_line2, 
                            :gender, :birthdate, :phone, :email, :user_agreement).merge(user_id: current_user.id)
  end
  
  def update_params
    params.require(:account).permit(:last_name_kanji, :last_name_kana, :first_name_kanji, :first_name_kana, 
                            :postal_code, :state, :city, :town, :kanji_line1, :kanji_line2, :kana_line1, :kana_line2, 
                            :gender, :birthdate, :phone, :email, :user_agreement)
  end
  
  def hankaku(str)
    if str == nil
      return nil
    else
      return NKF.nkf('-w -Z4', str)
    end
  end
  
end
