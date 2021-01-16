class ApplicationMailer < ActionMailer::Base
  default from: "support@#{ENV['TEPPAN_DOMAIN']}"
end
