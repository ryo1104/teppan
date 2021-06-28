# frozen_string_literal: true

class Business::IdcardsController < ApplicationController
  include StripeUtils

  def new
    @account = StripeAccount.find(params[:account_id])
    @idcard = StripeIdcard.new
  end

  def create
    @account = StripeAccount.find(params[:account_id])
    @idcard = @account.stripe_idcards.new(save_params)
    render :new and return unless @idcard.valid?

    upload_file_to_stripe
    @idcard.stripe_file_id = @file_upload_res['id']
    @idcard.save!

    stripe_acct_res = JSON.parse(Stripe::Account.update(@account.acct_id, @idcard.verification_docs).to_s)
    if stripe_acct_res['id'].present?
      redirect_to account_path(@account.id), notice: I18n.t('controller.idcards.received') and return
    else
      redirect_to account_path(@account.id), alert: I18n.t('controller.idcards.not_received') and return
    end
  end

  def destroy
    idcard = StripeIdcard.find(params[:id])
    account_id = idcard.stripe_account_id
    idcard.image.purge
    idcard.destroy!
    redirect_to account_path(account_id), notice: I18n.t('controller.idcards.deleted') and return
  end

  private

  def save_params
    params.require(:stripe_idcard).permit(:frontback, :image)
  end

  def file_to_upload
    params[:stripe_idcard][:image]
  end

  def upload_file_to_stripe
    file = file_to_upload
    name = file.original_filename
    @file_upload_res = @idcard.create_stripe_file(file, name)
    redirect_to account_path(@account.id), alert: 'ご本人様確認書類の保存に失敗しました。' and return if @file_upload_res['id'].blank?
  end
end
