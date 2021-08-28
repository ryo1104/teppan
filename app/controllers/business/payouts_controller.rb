# frozen_string_literal: true

class Business::PayoutsController < ApplicationController
  include StripeUtils

  def new
    res_accts = get_accounts
    redirect_to user_path(current_user.id), alert: res_accts[1] and return unless res_accts[0]

    res_amounts = get_amounts
    redirect_to account_path(@account.id), alert: res_amounts[1] and return unless res_amounts[0]
  end

  def create
    res_accts = get_accounts
    redirect_to user_path(current_user.id), alert: res_accts[1] and return unless res_accts[0]

    res_create = create_payout
    redirect_to new_account_payout_path(@account.id), alert: res_create[1] and return unless res_create[0]
  end

  private

  def my_account
    current_user.id == @account.user_id
  end

  def payout_params
    params.permit(:account_id, :amount)
  end

  def get_accounts
    @account = StripeAccount.find(params[:account_id])
    return [false, I18n.t('controller.general.no_access')] unless my_account

    @bank_info = @account.get_ext_account
    return [false, I18n.t('controller.payouts.no_bank_info')] unless @bank_info[0]

    [true, nil]
  end

  def get_amounts
    @balance = @account.get_balance
    return [false, I18n.t('controller.payouts.balance_not_retrieved')] unless @balance[0]

    [true, nil]
  end

  def create_payout
    @stripe_payout = StripePayout.create_stripe_payout(payout_params[:amount].to_i, @account.acct_id)
    unless @stripe_payout[0]
      logger.error "Stripe Payout returned error. account_id : #{@account.id}, stripe_response : #{@stripe_payout[1]}"
      return [false, I18n.t('controller.payouts.no_payout')]
    end

    @payout_ar = StripePayout.new(stripe_account_id: @account.id, payout_id: @stripe_payout[1]['id'],
                                  amount: @stripe_payout[1]['amount'].to_i)
    if @payout_ar.save
      flash[:notice] = I18n.t('controller.payouts.created')
      [true, nil]
    else
      logger.error "Failed to save StripePayout record : acct_id : #{@account.id}, payout_id : #{@stripe_payout[1]['id']}"
      [false, I18n.t('controller.payouts.record_not_saved')]
    end
  end
end
