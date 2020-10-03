class RemoveStripeExtAccount < ActiveRecord::Migration[6.0]
  def change
    drop_table :stripe_ext_accounts
  end
end
