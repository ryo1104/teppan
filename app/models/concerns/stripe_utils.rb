# frozen_string_literal: true

module StripeUtils
  extend ActiveSupport::Concern
  require 'stripe'
  require 'json'

  included do
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    Stripe.log_level = ENV['STRIPE_LOG_LEVEL']
  end

  # this will be rescued by Rambulance
  class StripeWebhookError < StandardError; end
end
