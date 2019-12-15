class TestMailer < ApplicationMailer
  def notify(message)
    @message = message
    @user = User.find(3)
    mail to: @user.email, subject: '【Teppan】 お問い合わせありがとうございます'
  end
end
