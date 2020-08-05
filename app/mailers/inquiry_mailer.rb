class InquiryMailer < ApplicationMailer
  
  def confirm_email(inquiry)
    @inquiry = inquiry
    if @inquiry.email.present?
      mail(to: @inquiry.email, subject: '[Teppan] お問い合わせありがとうございます')
    end
  end
  
end
