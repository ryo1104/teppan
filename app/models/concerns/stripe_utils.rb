module StripeUtils
  extend ActiveSupport::Concern
  require 'stripe'
  require 'json'
  require 'nkf'

  included do
    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
  end
  
  module ClassMethods
    def hankaku(str)
      if str == nil
        return nil
      else
        return NKF.nkf('-w -Z4', str)
      end
    end
  end

end