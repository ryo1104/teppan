# frozen_string_literal: true

class Users::Mailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'

  def confirmation_instructions(record, token, opts = {})
    opts[:subject] = '[Teppan] メールアドレス変更手続きを完了してください' unless record.unconfirmed_email.nil?
    super
  end
end
