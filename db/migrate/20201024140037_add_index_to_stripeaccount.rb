class AddIndexToStripeaccount < ActiveRecord::Migration[6.0]
  def up
    add_index :stripe_accounts, :user_id, :unique => true
    add_index :stripe_accounts, :acct_id, :unique => true
  end
  
  def down
    remove_index :stripe_accounts, :user_id
    remove_index :stripe_accounts, :acct_id
  end
end
