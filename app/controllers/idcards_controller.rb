class IdcardsController < ApplicationController
  before_action :authenticate_user!
  
  def new
    begin
      @account = Account.find(params[:account_id])
      @idcard = Idcard.new
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to account_path(params[:account_id]), alert: e.message and return
    end
  end
  
  def create
    begin
      @account = Account.find(params[:account_id])
      file = file_to_upload
      name = file.original_filename
      
      if !['.jpg', '.png'].include?(File.extname(name).downcase)
        redirect_to account_path(@account.id), alert: "JPG, PNGファイルのみアップロードできます。" and return
      elsif file.size > 5.megabyte
        redirect_to account_path(@account.id), alert: "5MBまでアップロードできます。" and return
      else
        File.open("tmp/#{name}", "wb") {|f|f.write(file.read)}
        file_upload = Stripe::FileUpload.create(
                                            {purpose: 'identity_document',
                                             file: File.open("tmp/#{name}", "r"),},
                                            {stripe_account: @account.stripe_acct_id})
        @file_upload_hash = JSON.parse(file_upload.to_s)
        if @file_upload_hash["id"].present?
          @idcard = @account.idcards.create!(save_params.merge(stripe_file_id: @file_upload_hash["id"]))
          Stripe::Account.update(@account.stripe_acct_id, verification_docs(@idcard.stripe_file_id, @idcard.frontback))
          File.delete("tmp/#{name}")
          @msg = "ファイルをアップロードしました。"
        else
          redirect_to account_path(@account.id), alert: "ファイルのアップロードに失敗しました。" and return
        end
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to account_path(params[:account_id]), alert: e.message and return
    end
  end
  
  def index
    begin
      @account = Account.find(params[:account_id])
      @idcards = @account.idcards
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to account_path(params[:account_id]), alert: e.message and return
    end
  end
  
  def destroy
    begin
      idcard = Idcard.find(params[:id])
      account_id = idcard.account_id
      idcard.image.purge
      idcard.destroy!
      redirect_to account_path(account_id), notice: "ファイルを削除しました。" and return
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to user_path(current_user.id), alert: e.message and return
    end
  end
  
  def verification_docs(fileid, frontback)
    return {
              individual:{
                verification:{
                  document:{
                    "#{frontback}":"#{fileid}"
                  },
                },
              },
            }
  end
  
  private

  def set_stripe_key
    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
  end
  
  def save_params
    params.require(:idcard).permit(:frontback, :image)
  end
  
  def file_to_upload
    params[:idcard][:image]
  end
  
end
