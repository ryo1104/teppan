class Business::PayoutsController < ApplicationController
  def new
    @account = Account.find(params[:account_id])
    @stripe_account_hash = @account.get_stripe_account
    @bank_info = Externalaccount.parse_bank_info(@stripe_account_hash)
    @balance = @account.balance
  rescue StandardError => e
    ErrorUtility.log_and_notify e
    redirect_to account_path(@account.id), alert: e.message and return
  end

  def create
    @account = Account.find(params[:account_id])
    @stripe_account_hash = @account.get_stripe_account

    if @stripe_account_hash['id'].present?
      @bank_info = Externalaccount.parse_bank_info(@stripe_account_hash)
      @stripe_payout_hash = Payout.create_stripe_payout(payout_amount[:amount], @stripe_account_hash['id'])

      if @stripe_payout_hash['id'].present?
        Payout.create!(account_id: @account.id, stripe_payout_id: @stripe_payout_hash['id'])
        @message = '銀行振込を受付けました。'
      else
        redirect_to new_account_payout_path(@account.id), alert: '銀行振込は行われませんでした。' and return
      end
    else
      redirect_to new_account_payout_path(@account.id), alert: '振込先口座が取得できませんでした。' and return
    end
  rescue StandardError => e
    ErrorUtility.log_and_notify e
    redirect_to new_account_payout_path(@account.id), alert: e.message and return
  end

  private

  def payout_amount
    params.permit(:amount)
  end
end
