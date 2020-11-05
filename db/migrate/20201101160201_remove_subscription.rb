class RemoveSubscription < ActiveRecord::Migration[6.0]
  def change
    drop_table :stripe_subscriptions
  end
end
