# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "support@#{ENV['EMAIL_DOMAIN']}"
end
