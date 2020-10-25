class RemoveAnotherIndexFromStripeaccount < ActiveRecord::Migration[6.0]
  def change
    remove_index :stripe_accounts, :acct_id
  end
end
