class Business::AccountsController < ApplicationController
  include StripeUtils

  def new
    @user = User.find(params[:user_id])
    redirect_to user_path(current_user.id), alert: 'ビジネスアカウントを作成するユーザー条件を満たしていません。' and return unless qualified(@user)
    if @user.stripe_account.present?
      redirect_to edit_account_path(@user.stripe_account.id), alert: 'すでにビジネスアカウントが存在します。' and return
    else
      @account_form = StripeAccountForm.new
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
    render :new and return if params[:back]
    redirect_to user_path(current_user.id), alert: 'ビジネスアカウントを作成するユーザー条件を満たしていません。' and return unless qualified(@user)

    @account_form = StripeAccountForm.new(form_params)
    render :new and return unless @account_form.valid?

    create_account
  end

  def edit
    @account = StripeAccount.find(params[:id])
    my_info(@account.user_id)
    @stripe_account_info = @account.get_connect_account
    if @stripe_account_info[0]
      @account_form = StripeAccountForm.new
      @account_form.set_info(@stripe_account_info[1])
    end
  end

  def update
    @account = StripeAccount.find(params[:id])
    render :edit and return if params[:back]

    my_info(@account.user_id)
    @account_form = StripeAccountForm.new(form_params)
    update_account_info
  end

  def show
    @account = StripeAccount.find(params[:id])
    my_info(@account.user_id)
    get_account_info
    update_account_status
    get_idcards unless @account_info['personal_info']['verification']['status'] == 'verified'
    get_balance
  end

  def destroy
    @account = StripeAccount.find(params[:id])
    my_info(@account.user_id)
    redirect_to account_path(@account.id), alert: 'アカウントに残高が残っています。' and return unless @account.zero_balance

    delete_account
  end

  private

  def form_params
    params.require(:stripe_account_form).permit(:last_name_kanji, :last_name_kana, :first_name_kanji, :first_name_kana,
                                                :postal_code, :state, :city, :town, :kanji_line1, :kanji_line2, :kana_line1, :kana_line2,
                                                :gender, :birthdate, :phone, :email, :user_agreement)
  end

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

  def get_account_info
    stripe_result_acct = @account.get_connect_account
    if stripe_result_acct[0]
      @account_info = stripe_result_acct[1]
    else
      Rails.logger.error "get_connect_account returned false : #{stripe_result_acct[1]}"
      redirect_to user_path(current_user.id), alert: 'ビジネスアカウント情報を取得できませんでした。' and return
    end
  end

  def update_account_status
    if @account_info['personal_info']['verification']['status'].present?
      unless @account.status == @account_info['personal_info']['verification']['status']
        if @account.update(status: @account_info['personal_info']['verification']['status'])
          @account.reload
        else
          raise ActiveRecord::RecordNotSaved, "update_account_status returned false. @account_info['personal_info'] = #{@account_info['personal_info']}"
        end
      end
    end
  end

  def update_account_info
    stripe_result = @account.update_connect_account(@account_form, request.remote_ip)
    if stripe_result[0]
      @account_info = stripe_result[1]
      @account.update!(status: @account_info['personal_info']['verification']['status'])
      redirect_to account_path(@account.id), notice: 'ビジネスアカウント情報が更新されました。' and return
    else
      Rails.logger.error "update_connect_account returned false : #{stripe_result[1]}"
      redirect_to edit_account_path(@account.id), alert: 'ビジネスアカウントを更新できませんでした。' and return
    end
  end

  def get_idcards
    cards = @account.find_idcards
    @frontcard = cards[0]
    @backcard = cards[1]
  end

  def get_balance
    stripe_result_balance = @account.get_balance
    if stripe_result_balance[0]
      @balance_info = stripe_result_balance[1]
    else
      Rails.logger.error "get_balance returned false : #{stripe_result_balance[1]}"
      redirect_to user_path(current_user.id), alert: '残高情報を取得できませんでした。' and return
    end
  end

  def create_account
    @stripe_result = StripeAccount.create_connect_account(@account_form, request.remote_ip)
    if @stripe_result[0]
      add_record
    else
      Rails.logger.error "create_connect_account returned false : #{@stripe_result[1]}.  User ID : #{@user.id}, email : #{@user.email}"
      redirect_to user_path(@user.id), alert: "ビジネスアカウントを作成できませんでした。#{@stripe_result[1]}" and return
    end
  end

  def add_record
    @account = StripeAccount.create(user_id: @user.id, acct_id: @stripe_result[1]['id'],
                                    status: @stripe_result[1]['personal_info']['verification']['status'])
    if @account.persisted?
      redirect_to account_path(@account.id), notice: 'ビジネスアカウントが作成されました。' and return
    else
      raise ActiveRecord::RecordNotSaved, "create account failed. user_id: #{@user.id}, acct_id: #{@stripe_result[1]['id']},
                                           status: #{@stripe_result[1]['personal_info']['verification']['status']}"
    end
  end

  def delete_account
    stripe_del_acct_res = @account.delete_connect_account
    if stripe_del_acct_res[0]
      if @account.destroy
        Rails.logger.error "account.destroy succeeded. Account id : #{@account.id}, delete_result = #{stripe_del_acct_res[1]}"
        redirect_to user_path(current_user.id), alert: '出金用アカウントを削除しました。' and return
      else
        Rails.logger.error "account.destroy failed. Account id : #{@account.id}"
        redirect_to account_path(@account.id), alert: '出金用アカウントを削除できませんでした。' and return
      end
    else
      Rails.logger.error "delete_connect_account failed : #{stripe_del_acct_res[1]}"
      redirect_to account_path(@account.id), alert: '出金用アカウントを削除できませんでした。' and return
    end
  end
end
