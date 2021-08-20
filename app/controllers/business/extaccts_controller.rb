# frozen_string_literal: true

class Business::ExtacctsController < ApplicationController
  include StripeUtils

  def new
    get_account(params[:account_id])
    if qualified(@account.user)
      @ext_acct_form = StripeExtAccountForm.new
    else
      redirect_to user_path(current_user.id), alert: I18n.t('controller.extaccts.ineligible') and return
    end
  end

  def create
    get_account(params[:account_id])
    @ext_acct_form = StripeExtAccountForm.new(create_params)
    render :new and return unless @ext_acct_form.valid?

    create_stripe_ext_acct

    if @account.update(ext_acct_id: @stripe_result[1]['id'])
      redirect_to account_path(@account.id), notice: I18n.t('controller.extaccts.created') and return
    else
      logger.error "Active Record update returned false. stripe_result = #{@stripe_result}"
      redirect_to account_path(@account.id), alert: I18n.t('controller.extaccts.not_created') and return
    end
  end

  def edit
    get_account(params[:account_id])
    @bank_info = @account.get_ext_account
    if @bank_info[0]
      @ext_acct_form = StripeExtAccountForm.new(@bank_info[1])
    else
      logger.error "get_ext_account returned false : #{@bank_info[1]}"
      redirect_to account_path(@account.id), alert: I18n.t('controller.extaccts.no_info') and return
    end
  end

  def update
    get_account(params[:account_id])
    @bank_info = @account.get_ext_account
    @old_stripe_bank_id = @account.ext_acct_id
    @ext_acct_form = StripeExtAccountForm.new(create_params)
    render :edit and return unless @ext_acct_form.valid?

    update_stripe_ext_acct

    if @account.update(ext_acct_id: @new_stripe_result[1]['id'])
      redirect_to account_path(@account.id), notice: I18n.t('controller.extaccts.updated') and return
    else
      logger.error "Active Record update returned false. account id #{@account.id}, #{@new_stripe_result[1]}"
      redirect_to edit_account_bank_path(@account.id), alert: I18n.t('controller.extaccts.not_updated') and return
    end
  end

  private

  def create_params
    params.require(:stripe_ext_account_form).permit(:bank_name, :branch_name, :account_number, :account_holder_name)
  end

  def get_account(id)
    @account = StripeAccount.find(id)
    redirect_to user_path(current_user.id), alert: I18n.t('controller.extaccts.account_non_exist') and return if @account.blank?
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

  def bank_inputs
    @stripe_bank_inputs = @ext_acct_form.create_bank_inputs
    unless @stripe_bank_inputs[0]
      logger.error "create_bank_inputs returned false. account id #{@account.id} : #{@stripe_bank_inputs[1]}"
      redirect_to edit_account_bank_path(@account.id), alert: I18n.t('controller.extaccts.not_updated') and return
    end
  end

  def create_stripe_ext_acct
    bank_inputs
    @stripe_result = @account.create_ext_account(@stripe_bank_inputs[1])
    unless @stripe_result[0]
      logger.error "create_ext_account returned false : #{@stripe_result[1]}"
      redirect_to user_path(@account.user_id), alert: I18n.t('controller.extaccts.not_created') and return
    end
  end

  def update_stripe_ext_acct
    bank_inputs
    # 新しい口座情報をStripeに登録しdefault accountに指定
    @new_stripe_result = @account.create_ext_account(@stripe_bank_inputs[1])
    if @new_stripe_result[0]
      # 古い口座情報をStripeから削除。注意：上のように先に新しいdefault accountを追加しておかないとエラーで弾かれる
      @delete_old_stripe_result = @account.delete_ext_account(@old_stripe_bank_id)
      unless @delete_old_stripe_result[0]
        logger.error "delete_ext_acct returned false. account id #{@account.id} : #{@delete_old_stripe_result[1]}"
        redirect_to edit_account_bank_path(@account.id), alert: I18n.t('controller.extaccts.not_updated') and return
      end
    else
      logger.error "create_ext_account returned false. account id #{@account.id} : #{@new_stripe_result[1]}"
      redirect_to edit_account_bank_path(@account.id), alert: I18n.t('controller.extaccts.not_updated') and return
    end
  end
end
