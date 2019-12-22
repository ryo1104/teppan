class ContactMailer < ApplicationMailer

  def notify(to_user_id, message)
    if message.present?
      @message = message
      @user = User.find(to_user_id)
      if @user.present?
        if @user.email.present?
          mail to: @user.email, subject: '【Teppan】 お問い合わせありがとうございます'
        else
          return [false, "recipient email address is blank"]
        end
      else
        return [false, "cannot find user. user_id : #{to_user_id}"]
      end
    else
      return [false, "mail message body is blank"]
    end
  end
end
