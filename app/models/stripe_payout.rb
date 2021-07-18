# frozen_string_literal: true

class StripePayout < ApplicationRecord
  belongs_to :stripe_account
  include StripeUtils

  validates   :stripe_account_id, presence: true
  validates   :payout_id, presence: true, uniqueness: { case_sensitive: true }
  validates   :amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100_000 }
  validate    :payout_id_check

  # custom validation
  def payout_id_check
    errors.add(:payout_id, 'payout_id does not start with po_') if payout_id.present? && !(payout_id.starts_with? 'po_')
  end

  def self.create_stripe_payout(amt, acct_id)
    check_inputs = StripePayout.check_inputs(amt, acct_id)
    return [false, check_inputs[1]] unless check_inputs[0]

    begin
      stripe_payout = JSON.parse(Stripe::Payout.create({ amount: amt, currency: 'jpy' },
                                                       { stripe_account: acct_id }).to_s)
    rescue StandardError => e
      ErrorUtility.log_and_notify e
      return [false, "Stripe error - #{e.message}"]
    end
    Rails.logger.info "stripe_payout created. Stripe response : #{stripe_payout}"
    [true, stripe_payout]
  end

  def self.check_inputs(amt, acct_id)
    return [false, 'amount is blank'] if amt.blank?
    return [false, 'amount is non integer'] unless amt.is_a?(Integer)
    return [false, "amount is zero or negative : #{amt}"] if amt.to_i <= 0
    return [false, 'acct_id is blank'] if acct_id.blank?
    return [false, "acct_id is invalid : #{acct_id}"] unless acct_id.starts_with? 'acct_'

    [true, nil]
  end
end
