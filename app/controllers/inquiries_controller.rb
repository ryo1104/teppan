class InquiriesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]

  def new
    @inquiry = Inquiry.new
  end

  def create
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.save
      InquiryMailer.confirm_email(@inquiry).deliver
    else
      render :new
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:email, :message)
  end
end
