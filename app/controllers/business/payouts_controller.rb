# frozen_string_literal: true

class Business::PayoutsController < ApplicationController
  include StripeUtils

  def new
    get_account(params[:account_id])
    redirect_to user_path(current_user.id), alert: I18n.t('controller.general.no_access') and return unless my_info(@account.user.id)

    get_bank_info
    get_balance
  end

  def create
    get_account(params[:account_id])
    redirect_to user_path(current_user.id), alert: I18n.t('controller.general.no_access') and return unless my_info(@account.user.id)

    get_bank_info
    create_stripe_payout
    create_payout_record
  end

  private

  def get_account(id)
    @account = StripeAccount.find(id)
    redirect_to user_path(current_user.id), alert: I18n.t('controller.payouts.account_non_exist') and return if @account.blank?
  end

  def get_bank_info
    @bank_info = @account.get_ext_account
    redirect_to new_account_payout_path(@account.id), alert: I18n.t('controller.payouts.no_bank_info') and return unless @bank_info[0]
  end

  def get_balance
    @balance = @account.get_balance
    redirect_to user_path(current_user.id), alert: I18n.t('controller.payouts.balance_not_retrieved') and return unless @balance[0]
  end

  def payout_amount
    params.permit(:account_id, :amount)
  end

  def my_info(user_id)
    if current_user.id == user_id
      true
    else
      raise ErrorUtils::AccessDeniedError, "current_user.id : #{current_user.id} is accessing account info for user_id : #{user_id}"
    end
  end

  def create_stripe_payout
    if payout_amount[:amount]
      @stripe_payout = StripePayout.create_stripe_payout(payout_amount[:amount], @account.acct_id)
      unless @stripe_payout[0]
        logger.error "Stripe Payout returned error. account_id : #{@account.id}, stripe_response : #{@stripe_payout[1]}"
        redirect_to new_account_payout_path(@account.id), alert: I18n.t('controller.payouts.no_payout') and return
      end
    else
      redirect_to new_account_payout_path(@account.id), alert: I18n.t('controller.general.unknown') and return
    end
  end

  def create_payout_record
    @payout = StripePayout.new(stripe_account_id: @account.id, payout_id: @stripe_payout[1]['id'], amount: @stripe_payout[1]['amount'].to_i)
    if @payout.save
      @message = '銀行振込を受付けました。'
    else
      logger.error "Failed to save StripePayout record : acct_id : #{@account.id}, payout_id : #{@stripe_payout[1]['id']}"
      redirect_to user_path(@user.id), alert: I18n.t('controller.payouts.record_not_saved') and return
    end
  end
end
