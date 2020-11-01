class TradesController < ApplicationController
  include StripeUtils
  before_action :load_tradeable, except: %i[webhook done]
  skip_before_action :authenticate_user!, only: %i[webhook done]
  protect_from_forgery except: %i[webhook done]

  def new
    get_checkout_inputs
    get_checkout_session
  end

  def webhook
    construct_stripe_event
    check_event
    execute_purchase
  end

  def done; end

  private

  def load_tradeable
    @resource, @id = request.path.split('/')[1, 2]
    @tradeable = @resource.singularize.classify.constantize.find(@id)
  end

  def get_checkout_inputs
    @buyer = current_user
    @price = @tradeable.price
    @ctax = Trade.get_ctax(@price)
    @charge_amount = @price + @ctax
    @seller = @tradeable.user
    @seller_revenue = Trade.get_seller_revenue(@price)
    @success_path = ENV['TRADE_SUCCESS_PATH']
    @cancel_path = ENV['TRADE_CANCEL_PATH']
  end

  def get_checkout_session
    @stripe_checkout_session = Trade.get_checkout_session(@tradeable, @buyer, @seller, @success_path, @cancel_path, @seller_revenue)
  end

  def construct_stripe_event
    @payload = request.body.read
    @endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']
    @sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    @event = JSON.parse(Stripe::Webhook.construct_event(@payload, @sig_header, @endpoint_secret).to_s)
  rescue JSON::ParserError
    render status: :bad_request  # Invalid payload
    nil
  rescue Stripe::SignatureVerificationError
    render status: :bad_request  # Invalid signature
    nil
  end

  def check_event
    if @event.key?('type')
      unless @event['type'] == 'checkout.session.completed'
        Rails.logger.error "event type is not checkout.session.completed, but instead #{@event['type']}."
        raise StripeUtils::StripeWebhookError, 'event type is not checkout.session.completed.'
      end
    else
      Rails.logger.error 'event type does not exist'
      raise StripeUtils::StripeWebhookError, 'event type does not exist'
    end
    if @event.key?('data')
      unless @event['data'].key?('object')
        Rails.logger.error 'event object does not exist'
        raise StripeUtils::StripeWebhookError, 'event object does not exist'
      end
    else
      Rails.logger.error 'event data does not exist'
      raise StripeUtils::StripeWebhookError, 'event data does not exist'
    end
  end

  def execute_purchase
    @result = Trade.fulfill_order(@event['data']['object'])
    unless @result[0]
      Rails.logger.error "fulfill order failed. #{@result[1]}"
      raise StripeUtils::StripeWebhookError, "決済処理が正しく完了できませんでした。 #{@result[1]}"
    end
  end
end
