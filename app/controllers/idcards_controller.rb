class IdcardsController < ApplicationController
  include StripeUtils

  def new
    @account = Account.find(params[:account_id])
    @idcard = Idcard.new
  rescue StandardError => e
    ErrorUtility.log_and_notify e
    redirect_to account_path(params[:account_id]), alert: e.message and return
  end

  def create
    @account = Account.find(params[:account_id])
    @idcard = @account.idcards.new(save_params)
    if @idcard.valid?
      @file = params[:idcard][:image]
      @name = @file.original_filename
      # @file_upload = Stripe::FileUpload.create( { purpose: 'identity_document', file: File.open("tmp/#{@name}", "r"),}, { stripe_account: @account.stripe_acct_id } )
      @idcard.transaction do
        File.open("tmp/#{@name}", 'wb') { |f| f.write(@file.read) }
        @file_upload = Stripe::File.create({ purpose: 'identity_document', file: File.open("tmp/#{@name}", 'r') })
        @file_upload_hash = JSON.parse(@file_upload.to_s)
        File.delete("tmp/#{@name}")
        if @file_upload_hash['id'].present?
          @idcard.save!
          @idcard.update!(stripe_file_id: @file_upload_hash['id'])
        else
          redirect_to account_path(@account.id), alert: 'ご本人様確認書類の保存に失敗しました。' and return
        end
      end
      @stripe_acct = Stripe::Account.update(@account.stripe_acct_id, @idcard.verification_docs)
      @stripe_acct_hash = JSON.parse(@stripe_acct.to_s)
      if @stripe_acct_hash['id'].present?
        redirect_to account_path(@account.id), notice: 'ご本人様確認書類を受領しました。' and return
      else
        redirect_to account_path(@account.id), alert: 'ご本人様確認書類の登録に失敗しました。' and return
      end
    else
      render :new
      end
  rescue StandardError => e
    ErrorUtility.log_and_notify e
    redirect_to account_path(params[:account_id]), alert: 'エラーが発生しました。' and return
  end

  def index
    @account = Account.find(params[:account_id])
    @idcards = @account.idcards
  rescue StandardError => e
    ErrorUtility.log_and_notify e
    redirect_to account_path(params[:account_id]), alert: e.message and return
  end

  def destroy
    idcard = Idcard.find(params[:id])
    account_id = idcard.account_id
    idcard.image.purge
    idcard.destroy!
    redirect_to account_path(account_id), notice: 'ファイルを削除しました。' and return
  rescue StandardError => e
    ErrorUtility.log_and_notify e
    redirect_to user_path(current_user.id), alert: e.message and return
  end

  private

  def save_params
    params.require(:idcard).permit(:frontback, :image)
  end

  def file_to_upload
    params[:idcard][:image]
  end
end
