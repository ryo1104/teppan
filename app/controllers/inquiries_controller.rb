class InquiriesController < ApplicationController

  def new
    @inquiry = Inquiry.new
  end

  def create
    begin
      @inquiry = Inquiry.new(inquiry_params)
      if @inquiry.save!
        InquiryMailer.confirm_email(@inquiry).deliver
        redirect_to root_path, notice: "お問い合わせを受け付けました。" and return
      else
        render :new
      end
    rescue => e
      ErrorUtility.log_and_notify e
      redirect_to root_path, alert: "エラーが発生しました。大変恐れ入りますが、しばらく時間を置いてから再度お試し下さい。" and return
    end
  end
  
  private

  def inquiry_params
    params.permit(:email, :message)
  end
end
