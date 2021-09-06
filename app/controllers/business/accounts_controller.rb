# frozen_string_literal: true

class Business::AccountsController < ApplicationController
  include StripeUtils

  def new
    @user = User.find(params[:user_id])
    redirect_to user_path(current_user.id), alert: I18n.t('controller.account.ineligible') and return unless qualified(@user)

    @account_form = if params[:stripe_account_form].present?
                      StripeAccountForm.new(form_params) # rendering back from confirm screen (back button)
                    else
                      StripeAccountForm.new
                    end
  end

  def confirm
    @mode = params[:mode]
    case @mode
    when 'new'
      @user = User.find(params[:user_id])
      @account_form = StripeAccountForm.new(form_params)
    when 'edit'
      @account = StripeAccount.find(params[:id])
      @account_form = StripeAccountForm.new(form_params)
      @user = @account.user
    end
  end

  def create
    @user = User.find(params[:user_id])
    redirect_to user_path(current_user.id), alert: I18n.t('controller.account.ineligible') and return unless qualified(@user)

    @account_form = StripeAccountForm.new(form_params)
    render :new and return if params[:back]
    render :new and return unless @account_form.valid?

    res_create_acct = create_account
    redirect_to user_path(@user.id), alert: res_create_acct[1] and return unless res_create_acct[0]

    redirect_to account_path(@account.id), notice: I18n.t('controller.account.created') and return
  end

  def edit
    @account = StripeAccount.find(params[:id])
    redirect_to user_path(current_user.id), alert: I18n.t('controller.general.no_access') unless my_info(@account.user)

    edit_form_res = get_edit_form
    redirect_to account_path(@account.id), alert: I18n.t('controller.account.not_retrieved') and return unless edit_form_res[0]

    @account_form = StripeAccountForm.new(edit_form_res[1])
  end

  def update
    @account = StripeAccount.find(params[:id])
    redirect_to user_path(current_user.id), alert: I18n.t('controller.general.no_access') and return unless my_info(@account.user)

    @account_form = StripeAccountForm.new(form_params)
    render :edit and return if params[:back]

    update_res = update_account_info
    if update_res[0]
      redirect_to account_path(@account.id), notice: I18n.t('controller.account.updated') and return
    else
      redirect_to edit_account_path(@account.id), alert: I18n.t('controller.account.not_updated') and return
    end
  end

  def show
    @account = StripeAccount.find(params[:id])
    redirect_to user_path(current_user.id), alert: I18n.t('controller.general.no_access') and return unless my_info(@account.user)

    account_info_res = get_account_info
    redirect_to user_path(current_user.id), alert: I18n.t('controller.account.no_info') and return unless account_info_res[0]

    if @account_info['personal_info']['verification']['status'] == 'verified'
      balance_res = get_balance
      redirect_to user_path(current_user.id), alert: I18n.t('controller.account.nil_balance') and return unless balance_res
    else
      get_idcards
    end
  end

  def destroy
    @account = StripeAccount.find(params[:id])
    redirect_to user_path(current_user.id), alert: I18n.t('controller.general.no_access') and return unless my_info(@account.user)
    redirect_to account_path(@account.id), alert: I18n.t('controller.account.residual') and return unless @account.zero_balance

    delete_res = delete_account
    if delete_res[0]
      redirect_to user_path(current_user.id), alert: I18n.t('controller.account.deleted') and return
    else
      redirect_to account_path(@account.id), alert: I18n.t('controller.account.not_deleted') and return
    end
  end

  private

  def form_params
    params.require(:stripe_account_form).permit(:last_name_kanji, :last_name_kana, :first_name_kanji, :first_name_kana,
                                                :postal_code, :kanji_state, :kanji_city, :kanji_town, :kanji_line1, :kanji_line2,
                                                :kana_line1, :kana_line2, :gender, :dob, :phone, :email, :verification)
  end

  def qualified(user)
    user.premium_user[0] && my_info(user)
  end

  def my_info(user)
    current_user.id == user.id
  end

  def get_account_info
    stripe_result_acct = @account.get_connect_account
    if stripe_result_acct[0]
      @account_info = stripe_result_acct[1]
      status_res = refresh_status
      if status_res[0]
        [true, stripe_result_acct[1]]
      else
        [false, status_res[1]]
      end
    else
      logger.error "get_connect_account returned false : #{stripe_result_acct[1]}"
      [false, stripe_result_acct[1]]
    end
  end

  def get_edit_form
    account_res = get_account_info
    return [false, account_res[1]] unless account_res[0]

    StripeAccountForm.convert_attributes(account_res[1]['personal_info'])
  end

  def update_account_info
    stripe_result = @account.update_connect_account(@account_form, request.remote_ip)
    if stripe_result[0]
      @account_info = stripe_result[1]
      logger.info "Stripe updated.  acct_id : #{@account_info['id']}, @account.id : #{@account.id}"
      refresh_status
    else
      logger.error "update_connect_account for account_id #{@account.id} returned false : #{stripe_result[1]}.
                    @account_form = #{@account_form.attributes.inspect}"
      [false, "update_connect_account for account_id #{@account.id} returned false : #{stripe_result[1]}."]
    end
  end

  def refresh_status
    if @account_info['personal_info']['verification']['status'].present?
      if @account.status == @account_info['personal_info']['verification']['status']
        [true, 'nothing to update']
      elsif @account.update(status: @account_info['personal_info']['verification']['status'])
        @account.reload
        logger.info "refresh_status succeeded. @account = #{@account.attributes.inspect}"
        [true, nil]
      else
        logger.error "refresh_status failed. ['personal_info'] = #{@account_info['personal_info']}"
        [false, "refresh_status failed. ['personal_info'] = #{@account_info['personal_info']}"]
      end
    else
      logger.error 'verification status does not exist in account_info'
      [false, 'verification status does not exist in account_info']
    end
  end

  def get_idcards
    unless @account_info['personal_info']['verification']['status'] == 'verified'
      cards = @account.stripe_idcards
      @frontcard = cards.find_by(frontback: 'front')
      @backcard = cards.find_by(frontback: 'back')
    end
  end

  def get_balance
    stripe_result_balance = @account.get_balance
    if stripe_result_balance[0]
      @balance_info = stripe_result_balance[1]
      @payout_threshold = ENV['PAYOUT_THRESHOLD'].to_i
      true
    else
      logger.error "get_balance returned false : #{stripe_result_balance[1]}"
      false
    end
  end

  def create_account
    @stripe_result = StripeAccount.create_connect_account(@account_form, request.remote_ip)
    if @stripe_result[0]
      logger.info "Stripe connect account created. acct_id : #{@stripe_result[1]['id']}"
      add_record
    else
      logger.error "create_connect_account returned false : #{@stripe_result[1]}.
                    User ID : #{@user.id}, email : #{@user.email}, @account_form = #{@account_form.attributes.inspect}"
      [false, I18n.t('controller.account.not_created')]
    end
  end

  def add_record
    @account = StripeAccount.new(user_id: @user.id, acct_id: @stripe_result[1]['id'],
                                 status: @stripe_result[1]['personal_info']['verification']['status'])
    if @account.save
      [true, nil]
    else
      logger.error "Active Record create failed. user_id: #{@user.id}, stripe_result: #{@stripe_result[1]}"
      [false, I18n.t('controller.account.not_created')]
    end
  end

  def delete_account
    stripe_del_acct_res = @account.delete_connect_account
    if stripe_del_acct_res[0]
      logger.info "Stripe delete succeeded. acct_id : #{stripe_del_acct_res[1]['id']}"
      if @account.destroy
        logger.info 'ActiveRecord destroy succeeded.'
        [true, nil]
      else
        logger.error "ActiveRecord destroy failed. Account id : #{@account.id}"
        [false, "ActiveRecord destroy failed. Account id : #{@account.id}"]
      end
    else
      logger.error "Stripe delete failed : #{stripe_del_acct_res[1]}"
      [false, "Stripe delete failed : #{stripe_del_acct_res[1]}"]
    end
  end
end
