class AddIndexToStripePayout < ActiveRecord::Migration[6.0]
  def up
    add_index :stripe_payouts, :payout_id, :unique => true
  end
  
  def down
    remove_index :stripe_payouts, :payout_id
  end
end
