class RenameStripemodels < ActiveRecord::Migration[6.0]
  def up
    rename_table  :stripeaccounts,  :stripe_accounts
    rename_table  :stripeexternalaccounts, :stripe_ext_accounts
    rename_table  :stripeidcards, :stripe_idcards
    rename_table  :stripepayouts, :stripe_payouts
    rename_table  :stripesubscriptions, :stripe_subscriptions
    rename_column :stripe_ext_accounts, :stripeaccount_id, :stripe_account_id
    rename_column :stripe_idcards,  :stripeaccount_id, :stripe_account_id
    rename_column :stripe_payouts,  :stripeaccount_id, :stripe_account_id
  end
  
  def down
    rename_column :stripe_ext_accounts, :stripe_account_id, :stripeaccount_id
    rename_column :stripe_idcards,  :stripe_account_id, :stripeaccount_id
    rename_column :stripe_payouts,  :stripe_account_id, :stripeaccount_id
    rename_table  :stripe_accounts, :stripeaccounts
    rename_table  :stripe_ext_accounts, :stripeexternalaccounts
    rename_table  :stripe_idcards, :stripeidcards
    rename_table  :stripe_payouts, :stripepayouts
    rename_table  :stripe_subscriptions, :stripesubscriptions
  end
end
