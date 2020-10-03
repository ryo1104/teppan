class StripeSubscription < ApplicationRecord
  belongs_to :user
  include StripeUtils

  def self.create_stripe_sub(stripe_cus_id, source_id)
    subscription = Stripe::Subscription.create({ customer: stripe_cus_id,
                                                 items: [{ plan: 'plan_F8dqnFoGCwICvt' }],
                                                 default_source: source_id,
                                                 trial_from_plan: 'true' })
    subscription_hash = JSON.parse(subscription.to_s)
    subscription_hash
  end

  def get_details
    subscription = Stripe::Subscription.retrieve(stripe_sub_id.to_s)
    subscription_hash = JSON.parse(subscription.to_s)
    subscription_hash
  end
end
