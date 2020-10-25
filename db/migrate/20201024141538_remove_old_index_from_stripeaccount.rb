class RemoveOldIndexFromStripeaccount < ActiveRecord::Migration[6.0]
  def change
    remove_index :stripe_accounts, name: 'index_stripe_accounts_on_acct_id'
  end
end
