module StripeUtils
  extend ActiveSupport::Concern
  require 'stripe'
  require 'json'
  require 'nkf'

  included do
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  end

  class JpKana
    def self.hankaku(str)
      if str.nil?
        nil
      else
        NKF.nkf('-w -Z4', str)
      end
    end
  end
end
