class Trade < ApplicationRecord
  include StripeUtils
  belongs_to :tradeable, polymorphic: true
  validates :buyer_id, presence: true, uniqueness: { scope: %i[seller_id tradeable_id tradeable_type],
                                                     message: I18n.t('activerecord.models.trade') + I18n.t('errors.messages.taken') }
  validates :seller_id, presence: true
  validate  :stripe_ch_id_check
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10_000 }

  $teppan_fee_rate = 0.15
  $c_tax_rate = 0.10

  # custom validation
  def stripe_ch_id_check
    if stripe_ch_id.present?
      errors.add(:stripe_ch_id, I18n.t('errors.messages.invalid')) unless stripe_ch_id.starts_with? 'ch_'
    else
      errors.add(:stripe_ch_id, I18n.t('errors.messages.empty'))
    end
  end

  def self.get_seller_revenue(amount)
    if amount.present?
      if amount.is_a?(Integer)
        (amount * (1 - $teppan_fee_rate)).floor
      else
        raise ArgumentError, 'amount is not a integer.'
      end
    else
      raise ArgumentError, 'amount is nil.'
    end
  end

  def self.get_ctax(amount)
    if amount.present?
      if amount.is_a?(Integer)
        (amount * $c_tax_rate).floor
      else
        raise ArgumentError, 'amount is not a integer.'
      end
    else
      raise ArgumentError, 'amount is nil.'
    end
  end

  def self.get_checkout_session(tradeable, buyer, seller, success_path, cancel_path, seller_revenue)
    checkout_params = if buyer.stripe_cus_id.present?
                        { customer: buyer.stripe_cus_id }
                      else
                        { customer_email: buyer.email }
                      end

    checkout_params.merge!({
                             success_url: success_path,
                             cancel_url: cancel_path,
                             payment_method_types: ['card'],
                             line_items: [
                               {
                                 name: tradeable.title,
                                 amount: tradeable.price,
                                 currency: 'jpy',
                                 quantity: 1
                               }
                             ],
                             metadata: { neta_id: tradeable.id },
                             payment_intent_data: {
                               transfer_data: {
                                 amount: seller_revenue,
                                 destination: seller.stripe_account.acct_id
                               },
                               # receipt_email: buyer.email
                               receipt_email: ENV['ADMIN_EMAIL_ADDRESS']
                             },
                           })

    JSON.parse(Stripe::Checkout::Session.create(checkout_params).to_s)
  end

  def self.fulfill_order(checkout_session)
    payment_intent_obj = JSON.parse(Stripe::PaymentIntent.retrieve(checkout_session['payment_intent']).to_s)
    return [false, 'Unable to retrieve payment intent object.'] if payment_intent_obj['id'].blank?

    trade_params = Trade.get_trade_params(payment_intent_obj, checkout_session)
    return [false, "Error retrieving trade params. #{trade_params[1]}"] unless trade_params[0]

    trade = Trade.new(trade_params[1])
    if trade.save
      [true, trade]
    else
      [false, "Failed to save Trade. params = #{trade_params[1]} "]
    end
  end

  def self.get_trade_params(payment_intent_obj, checkout_session)
    return [false, 'Unable to retrieve charges object.'] if payment_intent_obj['charges']['data'][0].blank?

    charge_obj = payment_intent_obj['charges']['data'][0]
    seller_info = Trade.get_seller_info(charge_obj)
    return [false, "Failed to get seller info. #{seller_info[1]}"] unless seller_info[0]

    buyer_info = Trade.get_buyer_info(checkout_session)
    return [false, "Failed to get buyer info. #{buyer_info[1]}"] unless buyer_info[0]

    neta_info = Trade.get_neta_id(checkout_session)
    return [false, "Failed to get neta_id. #{neta_info[1]}"] unless neta_info[0]

    trade_amount = Trade.create_trade_amounts(charge_obj)
    return [false, trade_amount[1]] unless trade_amount[0]

    trade_params = { tradeable_type: 'Neta', tradeable_id: neta_info[1], buyer_id: buyer_info[1].id, seller_id: seller_info[1].id,
                     stripe_ch_id: charge_obj['id'], stripe_pi_id: payment_intent_obj['id'] }
    trade_params.merge!(trade_amount[1])
    [true, trade_params]
  end

  def self.get_seller_info(charge_obj)
    return [false, 'Unable to find destination'] unless charge_obj.key?('destination')

    seller_acct = StripeAccount.find_by(acct_id: charge_obj['destination'])
    return [false, "Stripe account not found for #{charge_obj['destination']}"] if seller_acct.blank?

    seller = seller_acct.user
    return [false, 'Unable to get user instance.'] if seller.blank?

    [true, seller]
  end

  def self.get_buyer_info(checkout_session)
    if checkout_session['customer'].present?
      buyer = User.find_by(stripe_cus_id: checkout_session['customer'])
      return [false, "User not found for stripe_cus_id #{checkout_session['customer']}."] if buyer.blank?

      buyer.update!(stripe_cus_id: checkout_session['customer'])
    elsif checkout_session['customer_email'].present?
      buyer = User.find_by(email: checkout_session['customer_email'])
      return [false, "User not found for email #{checkout_session['customer_email']}."] if buyer.blank?

    else
      [false, 'Customer empty in checkout session.']
    end
    [true, buyer]
  end

  def self.get_neta_id(checkout_session)
    if checkout_session['metadata'].key?('neta_id')
      if checkout_session['metadata']['neta_id'].present?
        [true, checkout_session['metadata']['neta_id']]
      else
        [false, 'Neta_id is blank in checkout session.']
      end
    else
      [false, 'Neta_id does not exist in checkout session.']
    end
  end

  def self.create_trade_amounts(charge_obj)
    return [false, 'Amount does not exist in charge object.'] unless charge_obj.key?('amount')

    price = charge_obj['amount'].to_i
    return [false, 'Unable to get price.'] if price.blank?
    return [false, 'Price is not positive.'] unless price > 0

    seller_revenue = Trade.get_seller_revenue(price)
    fee = price - seller_revenue
    c_tax = Trade.get_ctax(price)
    [true, { price: price, seller_revenue: seller_revenue, fee: fee, c_tax: c_tax }]
  end
end
