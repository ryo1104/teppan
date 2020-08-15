class InquiryMailer < ApplicationMailer
  def confirm_email(inquiry)
    @inquiry = inquiry
    mail(to: @inquiry.email, subject: '[Teppan] お問い合わせありがとうございます') if @inquiry.email.present?
  end
end
