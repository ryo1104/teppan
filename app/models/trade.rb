# frozen_string_literal: true

class Trade < ApplicationRecord
  include StripeUtils
  belongs_to :tradeable, polymorphic: true
  validates :buyer_id, presence: true, uniqueness: { scope: %i[seller_id tradeable_id tradeable_type],
                                                     message: I18n.t('activerecord.models.trade') + I18n.t('errors.messages.taken') }
  validates :seller_id, presence: true
  validate  :stripe_ch_id_check
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10_000 }

  # custom validation
  def stripe_ch_id_check
    if stripe_ch_id.present?
      errors.add(:stripe_ch_id, I18n.t('errors.messages.invalid')) unless stripe_ch_id.starts_with? 'ch_'
    else
      errors.add(:stripe_ch_id, I18n.t('errors.messages.empty'))
    end
  end

  # Buyer pays neta price + 10% tax.
  # Seller gets 75% of above tax inclusive amount.
  # Fee is split into Stripe fee 3-4%, and remaining to Teppan.
  # <Example>
  #  Price excluding tax : 100
  #  Tax : 10 = 100 * 10%
  #  Seller revenue : 82 = 110 * 75%
  #  Fee : 18 = 100 - 82
  #    Stripe fee : 4 = 110 * 4%
  #    Income to Teppan : 14 = 18 - 4
  def self.get_seller_revenue(total_amount)
    if total_amount.present?
      if total_amount.is_a?(Integer)
        (total_amount * 0.75).floor
      else
        raise ArgumentError, 'total_amount is not a integer.'
      end
    else
      raise ArgumentError, 'total_amount is nil.'
    end
  end

  def self.get_ctax(amount)
    if amount.present?
      if amount.is_a?(Integer)
        (amount * 0.10).floor
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
                                 quantity: 1,
                                 tax_rates: ['txr_1JSHEcEThOtNwrS9iC7arZxH']
                               }
                             ],
                             metadata: {
                               neta_id: tradeable.id, buyer_id: buyer.id, seller_id: seller.id
                             },
                             payment_intent_data: {
                               transfer_data: {
                                 amount: seller_revenue,
                                 destination: seller.stripe_account.acct_id
                               },
                               # receipt_email: buyer.email
                               receipt_email: ENV['ADMIN_EMAIL_ADDRESS']
                             }
                           })

    JSON.parse(Stripe::Checkout::Session.create(checkout_params).to_s)
  end

  def self.process_event(event)
    return [false, 'event type does not exist'] unless event.key?('type')
    return [false, "event type not checkout.session.completed but #{event['type']}"] unless event['type'] == 'checkout.session.completed'
    return [false, 'event data does not exist'] unless event.key?('data')
    return [false, 'event object does not exist'] unless event['data'].key?('object')

    Trade.update_customer_id(event)
  end

  def self.update_customer_id(event)
    return [false, 'customer does not exist'] unless event['data']['object'].key?('customer')
    return [false, 'buyer_id does not exist'] unless event['data']['object']['metadata'].key?('buyer_id')

    buyer = User.find(event['data']['object']['metadata']['buyer_id'])
    return [false, 'cannot find buyer user.'] if buyer.blank?
    return [true, nil] if buyer.stripe_cus_id.present?

    buyer.stripe_cus_id = event['data']['object']['customer']
    if buyer.save
      [true, nil]
    else
      [false, 'cannot save buyer user.']
    end
  end

  def self.execute_order(checkout_session)
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

    neta_info = Trade.get_neta_info(checkout_session)
    return [false, "Failed to get neta info. #{neta_info[1]}"] unless neta_info[0]

    trade_amount = Trade.parse_trade_amounts(charge_obj, checkout_session)
    return [false, "Failed to get trade amounts. #{trade_amount[1]}"] unless trade_amount[0]

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

  def self.get_neta_info(checkout_session)
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

  def self.parse_trade_amounts(charge_obj, checkout_session)
    inputs_exist = trade_inputs_exist(charge_obj, checkout_session)
    return [false, inputs_exist[1]] unless inputs_exist[0]

    price = checkout_session['amount_subtotal'].to_i
    return [false, 'Price is zero or negative.'] unless price.positive?

    seller_revenue = charge_obj['transfer_data']['amount'].to_i
    return [false, 'Seller revenue is zero or negative.'] unless seller_revenue.positive?

    fee = price - seller_revenue
    return [false, 'Fee is zero or negative.'] unless fee.positive?

    c_tax = checkout_session['total_details']['amount_tax'].to_i
    return [false, 'Tax is zero or negative.'] unless c_tax.positive?

    balance_check = checkout_session['amount_total'].to_i - seller_revenue - fee - c_tax
    return [false, 'amounts do not balance.'] unless balance_check.zero?

    [true, { price: price, seller_revenue: seller_revenue, fee: fee, c_tax: c_tax }]
  end

  def self.get_trades_info(who, id, tradeable_type)
    trades = case who
             when 'seller'
               Trade.where(seller_id: id, tradeable_type: tradeable_type).order('created_at DESC')
             when 'buyer'
               Trade.where(buyer_id: id, tradeable_type: tradeable_type).order('created_at DESC')
             end
    if trades.present?
      ids = collect_ids(trades)
      buyers_hash = User.details_from_ids(ids['buyer_ids'])
      neta_hash = Neta.details_from_ids(ids['tradeable_ids'])
      review_hash = Review.details_from_ids(tradeable_type, ids['tradeable_ids'])
      sold_netas_info = sold_netas_details(trades, buyers_hash, neta_hash, review_hash)
      [true, sold_netas_info]
    else
      [false, "No sold netas found for user_id #{id}"]
    end
  end

  def self.collect_ids(trades)
    tradeable_ids = []
    buyer_ids = []
    trades.each do |trade|
      buyer_ids << trade.buyer_id
      tradeable_ids << trade.tradeable_id
    end
    buyer_ids.uniq!
    tradeable_ids.uniq!
    { 'buyer_ids' => buyer_ids, 'tradeable_ids' => tradeable_ids }
  end

  def self.sold_netas_details(trades, buyers_hash, neta_hash, review_hash)
    if trades.present?
      sold_netas_info = []
      trades.each do |trade|
        rate = if review_hash.key?("neta_#{trade.tradeable_id}_user_#{trade.buyer_id}")
                 review_hash["neta_#{trade.tradeable_id}_user_#{trade.buyer_id}"]['rate']
               end
        sold_netas_info << {
          'traded_at' => trade.created_at,
          'title' => neta_hash[trade.tradeable_id]['title'],
          'price' => trade.price,
          'buyer_id' => trade.buyer_id,
          'buyer_nickname' => buyers_hash[trade.buyer_id]['nickname'],
          'review_rate' => rate
        }
      end
      sold_netas_info
    else
      false
    end
  end

  def self.trade_inputs_exist(charge_obj, checkout_session)
    return [false, 'Amount subtotal does not exist in checkout_session.'] unless checkout_session.key?('amount_subtotal')
    return [false, 'Amount subtotal is blank.'] if checkout_session['amount_subtotal'].blank?
    return [false, 'Transfer data does not exist in charge_obj.'] unless charge_obj.key?('transfer_data')
    return [false, 'Transfer amount does not exist in charge_obj.'] unless charge_obj['transfer_data'].key?('amount')
    return [false, 'Transfer amount is blank.'] if charge_obj['transfer_data']['amount'].blank?
    return [false, 'Total details does not exist in checkout_session.'] unless checkout_session.key?('total_details')
    return [false, 'Amount tax does not exist in checkout_session.'] unless checkout_session['total_details'].key?('amount_tax')
    return [false, 'Amount tax is blank.'] if checkout_session['total_details']['amount_tax'].blank?

    [true, nil]
  end

  private_class_method :sold_netas_details, :collect_ids, :trade_inputs_exist
end
