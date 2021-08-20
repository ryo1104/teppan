# frozen_string_literal: true

class TradesController < ApplicationController
  include StripeUtils
  before_action :load_tradeable, except: %i[webhook]
  skip_before_action :authenticate_user!, only: %i[webhook]
  protect_from_forgery except: %i[webhook]

  def new
    get_checkout_inputs
    get_checkout_session
  end

  def webhook
    construct_stripe_event
    process_event
    execute_order
  end

  private

  def load_tradeable
    @resource, @id = request.path.split('/')[1, 2]
    @tradeable = @resource.singularize.classify.constantize.find(@id)
  end

  def tradeable_path(tradeable)
    "/#{tradeable.class.name.pluralize.downcase}/#{tradeable.id}"
  end

  def get_checkout_inputs
    @buyer = current_user
    @price = @tradeable.price
    @ctax = Trade.get_ctax(@price)
    @seller = @tradeable.user
    @seller_revenue = Trade.get_seller_revenue(@price)
    @success_path = "#{ENV['HOST_URL']}#{tradeable_path(@tradeable)}"
    @cancel_path = "#{ENV['HOST_URL']}#{tradeable_path(@tradeable)}/trades/new"
  end

  def get_checkout_session
    @stripe_checkout_session = Trade.get_checkout_session(@tradeable, @buyer, @seller, @success_path, @cancel_path, @seller_revenue)
  end

  def construct_stripe_event
    payload = request.body.read
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    @event = JSON.parse(Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret).to_s)
  rescue JSON::ParserError
    render status: :bad_request  # Invalid payload
    nil
  rescue Stripe::SignatureVerificationError
    render status: :bad_request  # Invalid signature
    nil
  end

  def process_event
    ev_result = Trade.process_event(@event)
    unless ev_result[0]
      logger.error "Process event failed. #{ev_result[1]}"
      raise StripeUtils::StripeWebhookError, "Process event failed. #{ev_result[1]}"
    end
  end

  def execute_order
    ex_result = Trade.execute_order(@event['data']['object'])
    unless ex_result[0]
      logger.error "Execute order failed. #{ex_result[1]}"
      raise StripeUtils::StripeWebhookError, "Execute order failed. #{ex_result[1]}"
    end
  end
end
