module StripeUtils
  extend ActiveSupport::Concern
  require 'stripe'
  require 'json'
  require 'nkf'

  included do
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  end

  # this will be rescued by Rambulance
  class StripeWebhookError < StandardError; end
end
