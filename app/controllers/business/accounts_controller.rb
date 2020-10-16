class Business::AccountsController < ApplicationController
  include StripeUtils

  def new
    @user = User.find(params[:user_id])
    if qualified(@user)
      if @user.stripe_account.present?
        redirect_to edit_account_path(@user.stripe_account.id), alert: 'すでにビジネスアカウントが存在します。' and return
      else
        @account_form = StripeAccountForm.new
      end
    else
      redirect_to user_path(current_user.id), alert: 'ビジネスアカウントを作成するユーザー条件を満たしていません。' and return
    end
  end

  def confirm
    @mode = params[:mode]
    if @mode == 'new'
      @user = User.find(params[:user_id])
      @account_form = StripeAccountForm.new(form_params)
    elsif @mode == 'edit'
      @account = StripeAccount.find(params[:id])
      @account_form = StripeAccountForm.new(form_params)
      @user = @account.user
    end
  end

  def create
    @user = User.find(params[:user_id])
    if qualified(@user)
      @account_form = StripeAccountForm.new(form_params)
      if params[:back]
        render :new and return
      else
        if @account_form.valid?
          @account = StripeAccount.new
          @stripe_result = @account.create_stripe_account(@account_form, request.remote_ip)
          if @stripe_result[0]
            @account.assign_attributes(user_id: @user.id, acct_id: @stripe_result[1]['id'], status: @stripe_result[1]['personal_info']['verification']['status'])
            if @account.save
              redirect_to account_path(@account.id), notice: 'ビジネスアカウントが作成されました。' and return
            else
              Rails.logger.error "Failed to save StripeAccount record : user_id : #{@user.id}, acct_id : #{@stripe_result[1]['id']}"
              redirect_to user_path(@user.id), alert: "ビジネスアカウントを作成できませんでした。" and return
            end
          else
            Rails.logger.error "create_stripe_account returned false : #{@stripe_result[1]}"
            redirect_to user_path(@user.id), alert: "ビジネスアカウントを作成できませんでした。#{@stripe_result[1]}" and return
          end
        else
          render :new and return
        end
      end
    else
      Rails.logger.info "User ID #{current_user.id} is not qualified to create a sellers account."
      redirect_to user_path(current_user.id), alert: 'ビジネスアカウントを作成するユーザー条件を満たしていません。' and return
    end
  end

  def edit
    @account = StripeAccount.find(params[:id])
    if my_info(@account.user_id)
      @stripe_account_info = @account.get_stripe_account
      if @stripe_account_info[0]
        @account_form = StripeAccountForm.new
        @account_form.set_info(@stripe_account_info[1])
      end
      # @account_info = Account.extract_account_info(@stripe_account)
      # stripe_result_acct = @account.get_stripe_account
      # if stripe_result_acct[0]
      #   @account_info = stripe_result_acct[1]
      # else
      #   Rails.logger.error "get_stripe_account returned false : #{stripe_result_acct[1]}"
      #   redirect_to user_path(current_user.id), alert: "アカウント情報を取得できませんでした。" and return
      # end
    else
      redirect_to user_path(current_user.id), alert: 'アクセス権限がありません。' and return
    end
  end

  def update
    @account = StripeAccount.find(params[:id])
    if my_info(@account.user_id)
      @account_form = StripeAccountForm.new(form_params)
      if params[:back]
        render :edit and return
      else
        @stripe_result = @account.update_stripe_account(@account_form, request.remote_ip)
        if @stripe_result[0]
          @account_info = @stripe_result[1]
          @account.update!(status: @account_info['personal_info']['verification']['status'])
          redirect_to account_path(@account.id), notice: 'ビジネスアカウント情報が更新されました。' and return
        else
          Rails.logger.error "update_stripe_account returned false : #{@stripe_result[1]}"
          redirect_to edit_account_path(@account.id), alert: 'ビジネスアカウントを更新できませんでした。' and return
        end
      end
    end
  end

  def show
    @account = StripeAccount.find(params[:id])
    my_info(@account.user_id)

    stripe_result_acct = @account.get_stripe_account
    if stripe_result_acct[0]
      @account_info = stripe_result_acct[1]
    else
      Rails.logger.error "get_stripe_account returned false : #{stripe_result_acct[1]}"
      redirect_to user_path(current_user.id), alert: 'ビジネスアカウント情報を取得できませんでした。' and return
    end

    if @account_info['personal_info']['verification']['status'].present?
      latest_stripe_status = @account_info['personal_info']['verification']['status']
      if latest_stripe_status != @account.status
        @account.reload if @account.update(status: latest_stripe_status)
      end
      unless @account_info["personal_info"]["verification"]["status"] == "verified"
        cards = @account.find_idcards
        @frontcard = cards[0]
        @backcard = cards[1]
      end
    end

    stripe_result_balance = @account.get_stripe_balance
    if stripe_result_balance[0]
      @balance_info = stripe_result_balance[1]
    else
      Rails.logger.error "get_stripe_balance returned false : #{stripe_result_balance[1]}"
      redirect_to user_path(current_user.id), alert: '残高情報を取得できませんでした。' and return
    end
    
    # puts "ACCOUNT_INFO : "
    # puts @account_info
    
  end

  def destroy
    @account = StripeAccount.find(params[:id])
    if my_info(@account.user_id)
      if @account.zero_balance
        stripe_result_acct = @account.delete_stripe_account
        if stripe_result_acct[0]
          @delete_result = stripe_result_acct[1]
          if @account.destroy!
            Rails.logger.error "account.destroy succeeded. Account id : #{@account.id}, @delete_result = #{@delete_result}"
            redirect_to user_path(current_user.id), alert: '出金用アカウントを削除しました。' and return
          else
            Rails.logger.error "account.destroy failed. Account id : #{@account.id}"
            redirect_to account_path(@account.id), alert: '出金用アカウントを削除できませんでした。' and return
          end
        else
          Rails.logger.error "delete_stripe_account returned false : #{stripe_result_acct[1]}"
          redirect_to account_path(@account.id), alert: '出金用アカウントを削除できませんでした。' and return
        end
      else
        redirect_to account_path(@account.id), alert: 'アカウントに残高が残っています。' and return
      end
    end
  end

  private

  def my_info(user_id)
    if current_user.id == user_id
      true
    else
      raise ErrorUtils::AccessDeniedError, "current_user.id : #{current_user.id} is accessing account info for user_id : #{user_id}"
    end
  end

  def qualified(user)
    if my_info(user.id) && current_user.premium_user[0]
      true
    else
      false
    end
  end

  def create_params
    params.require(:stripe_account_form).permit(:last_name_kanji, :last_name_kana, :first_name_kanji, :first_name_kana,
                                                :postal_code, :state, :city, :town, :kanji_line1, :kanji_line2, :kana_line1, :kana_line2,
                                                :gender, :birthdate, :phone, :email, :user_agreement).merge(user_id: current_user.id)
  end

  def form_params
    params.require(:stripe_account_form).permit(:last_name_kanji, :last_name_kana, :first_name_kanji, :first_name_kana,
                                                :postal_code, :state, :city, :town, :kanji_line1, :kanji_line2, :kana_line1, :kana_line2,
                                                :gender, :birthdate, :phone, :email, :user_agreement)
  end

  def hankaku(str)
    if str.nil?
      nil
    else
      NKF.nkf('-w -Z4', str)
    end
  end
  
end
