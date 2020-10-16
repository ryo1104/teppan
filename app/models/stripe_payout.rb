class StripePayout < ApplicationRecord
  belongs_to :stripe_account
  include StripeUtils

  def self.create_stripe_payout(amt, stripe_account_id)
    begin
    stripe_payout = JSON.parse(Stripe::Payout.create({ amount: amt, currency: 'jpy' }, 
                                                     { stripe_account: stripe_account_id }
                                                    ).to_s)
    rescue => e
      ErrorUtility.log_and_notify e
      return [false, "Stripe error - #{e.message}"]
    end
    stripe_payout
  end
end
