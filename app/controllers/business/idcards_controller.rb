class Business::IdcardsController < ApplicationController
  include StripeUtils

  def new
    @account = StripeAccount.find(params[:account_id])
    @idcard = StripeIdcard.new
  end

  def create
    @account = StripeAccount.find(params[:account_id])
    @idcard = @account.stripe_idcards.new(save_params)
    if @idcard.valid?
      @file = file_to_upload
      @name = @file.original_filename
      @file_upload_hash = @idcard.create_stripe_file(@file, @name)
      if @file_upload_hash['id'].present?
        @idcard.save!
        @idcard.update!(stripe_file_id: @file_upload_hash['id'])
      else
        redirect_to account_path(@account.id), alert: 'ご本人様確認書類の保存に失敗しました。' and return
      end
      @stripe_acct_hash = JSON.parse(Stripe::Account.update(@account.acct_id, @idcard.verification_docs).to_s)
      if @stripe_acct_hash['id'].present?
        redirect_to account_path(@account.id), notice: 'ご本人様確認書類を受領しました。' and return
      else
        redirect_to account_path(@account.id), alert: 'ご本人様確認書類の登録に失敗しました。' and return
      end
    else
      render :new
    end
  end

  def destroy
    idcard = StripeIdcard.find(params[:id])
    account_id = idcard.stripe_account_id
    idcard.image.purge
    idcard.destroy!
    redirect_to account_path(account_id), notice: 'ファイルを削除しました。' and return
  end

  private

  def save_params
    params.require(:stripe_idcard).permit(:frontback, :image)
  end

  def file_to_upload
    params[:stripe_idcard][:image]
  end
end
