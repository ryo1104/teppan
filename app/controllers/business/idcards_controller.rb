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
    record_file_id
    update_connected_account
  end

  def destroy
    idcard = StripeIdcard.find(params[:id])
    account_id = idcard.stripe_account_id
    idcard.destroy!
    redirect_to account_path(account_id), notice: I18n.t('controller.idcards.deleted') and return
  end

  private

  def save_params
    params.require(:stripe_idcard).permit(:frontback)
  end

  def upload_file_to_stripe
    file = params[:stripe_idcard][:image]
    redirect_to account_path(@account.id), alert: I18n.t('controller.idcards.no_file') and return if file.blank?

    @file_upload_res = @idcard.create_stripe_file(file, file.original_filename)
    redirect_to account_path(@account.id), alert: I18n.t('controller.idcards.not_received') and return if @file_upload_res['id'].blank?
  end

  def record_file_id
    @idcard.stripe_file_id = @file_upload_res['id']
    @idcard.save!
  end

  def update_connected_account
    stripe_acct_res = JSON.parse(Stripe::Account.update(@account.acct_id, @idcard.verification_docs).to_s)
    if stripe_acct_res['id'].present?
      redirect_to account_path(@account.id), notice: I18n.t('controller.idcards.received') and return
    else
      redirect_to account_path(@account.id), alert: I18n.t('controller.idcards.not_received') and return
    end
  end
end
