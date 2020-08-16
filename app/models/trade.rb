class Trade < ApplicationRecord
  include StripeUtils
  belongs_to :tradeable, polymorphic: true
  validates :buyer_id, presence: true, uniqueness: { scope: %i[seller_id tradeable_id tradeable_type], message: '重複した取引情報が存在しています。' }
  validates :seller_id, presence: true
  validate  :stripe_charge_id_check
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10_000 }

  $teppan_fee_rate = 0.15

  # custom validation
  def stripe_charge_id_check
    if stripe_charge_id.present?
      errors.add(:stripe_charge_id, 'invalid stripe_charge_id') unless stripe_charge_id.starts_with? 'ch_'
    else
      errors.add(:stripe_charge_id, 'blank stripe_charge_id')
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
        (amount * 0.1).floor
      else
        raise ArgumentError, 'amount is not a integer.'
      end
    else
      raise ArgumentError, 'amount is nil.'
    end
  end

  def self.get_checkout_session(tradeable, buyer, seller, success_path, cancel_path, seller_revenue)
    result = Stripe::Checkout::Session.create({ customer_email: buyer.email,
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
                                                payment_intent_data: {
                                                  transfer_data: {
                                                    amount: seller_revenue,
                                                    destination: seller.account.stripe_acct_id
                                                  },
                                                  # receipt_email: buyer.email
                                                  receipt_email: ENV['ADMIN_EMAIL_ADDRESS']
                                                } })
    JSON.parse(result.to_s)
  end

  def self.charge(source, buyer, seller, tradeable, charge_amount, seller_revenue)
    result_hash = {}

    # 顧客に紐付いているカードで支払い
    if source['object'] == 'customer' || source['object'] == 'card'
      charge = Stripe::Charge.create({ amount: charge_amount,
                                       currency: 'jpy',
                                       customer: buyer.stripe_cus_id,
                                       transfer_data: {
                                         amount: seller_revenue, # 売り手へいくら配分するか
                                         destination: seller.account.stripe_acct_id # 売り手のアカウント
                                       } })
      charge_result = JSON.parse(charge.to_s)
      result_hash.merge!({ 'charge_result' => charge_result })

    # Stripe残高で支払い
    elsif source['object'] == 'account'
      # 買い手のStripe残高から代金を徴収
      charge = Stripe::Charge.create({ amount: charge_amount,
                                       currency: 'jpy',
                                       source: source['id'],
                                       customer: buyer.stripe_cus_id,
                                       transfer_group: "Product: #{tradeable.class.name}-#{tradeable.id}, BuyerID: #{buyer.id}" })
      # 売り手に手数料を差し引いた金額を転送
      transfer = Stripe::Transfer.create({  amount: seller_revenue,
                                            currency: 'jpy',
                                            destination: seller.account.stripe_acct_id,
                                            transfer_group: "Product: #{tradeable.class.name}-#{tradeable.id}, BuyerID: #{buyer.id}" })

      charge_result = JSON.parse(charge.to_s)
      result_hash.merge!({ 'charge_result' => charge_result })

      transfer_result = JSON.parse(transfer.to_s)
      result_hash.merge!({ 'transfer_result' => transfer_result })
    else
      raise StandardError, '不明な支払元です。'
    end
    result_hash
  end
end
