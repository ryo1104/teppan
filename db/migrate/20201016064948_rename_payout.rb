class RenamePayout < ActiveRecord::Migration[6.0]
  def up
    rename_column :stripe_payouts,  :stripe_payout_id, :payout_id
  end
  
  def down
    rename_column :stripe_payouts,  :payout_id, :stripe_payout_id
  end
end
