# frozen_string_literal: true

class Business::PayoutsController < ApplicationController
  include StripeUtils

  def new
    @account = StripeAccount.find(params[:account_id])
    if @account.present?
      if my_info(@account.user.id)
        @bank_info = @account.get_ext_account
        if @bank_info[0]
          @balance = @account.get_balance
          redirect_to user_path(current_user.id), alert: '出金可能残高を取得できませんでした。' and return unless @balance[0]
        else
          Rails.logger.error "Failed to parse bank info from Stripe Account object : #{@bank_info[1]}"
          redirect_to user_path(current_user.id), alert: '銀行口座情報を取得できませんでした。' and return
        end
      else
        redirect_to user_path(current_user.id), alert: 'アクセス権がありません。' and return
      end
    else
      redirect_to user_path(current_user.id), alert: 'ビジネスアカウントを取得できませんでした。' and return
    end
  end

  def create
    @account = StripeAccount.find(params[:account_id])
    if @account.present?
      if my_info(@account.user.id)
        @bank_info = @account.get_ext_account
        if @bank_info[0]
          if payout_amount[:amount]
            @stripe_payout = StripePayout.create_stripe_payout(payout_amount[:amount], @account.acct_id)
            if @stripe_payout[0]
              @payout = StripePayout.new(stripe_account_id: @account.id, payout_id: @stripe_payout[1]['id'], amount: @stripe_payout[1]['amount'].to_i)
              if @payout.save
                @message = '銀行振込を受付けました。'
              else
                Rails.logger.error "Failed to save StripePayout record : acct_id : #{@account.id}, payout_id : #{@stripe_payout[1]['id']}"
                redirect_to user_path(@user.id), alert: '銀行振込を受付けましたが、一部エラーが発生しています。管理者にお問い合わせ下さい。' and return
              end
            else
              Rails.logger.error "Stripe Payout returned error : #{@stripe_payout[1]}"
              redirect_to new_account_payout_path(@account.id), alert: '銀行振込は行われませんでした。' and return
            end
          else
            redirect_to new_account_payout_path(@account.id), alert: 'システムエラーが発生しました。' and return
          end
        else
          redirect_to new_account_payout_path(@account.id), alert: '振込先口座が取得できませんでした。' and return
        end
      else
        redirect_to user_path(current_user.id), alert: 'アクセス権がありません。' and return
      end
    else
      redirect_to user_path(current_user.id), alert: 'ビジネスアカウントを取得できませんでした。' and return
    end
  end

  private

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
end
