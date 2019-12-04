class Payout < ApplicationRecord
  belongs_to  :account
  include StripeUtils
  
  def self.create_stripe_payout(amt, stripe_account_id)
    stripe_payout = Stripe::Payout.create({amount: amt, currency: 'jpy',}, 
                                   {stripe_account: stripe_account_id}
                                   )
    stripe_payout_hash = JSON.parse(stripe_payout.to_s)
    return stripe_payout_hash
  end
end
