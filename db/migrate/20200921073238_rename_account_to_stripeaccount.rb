class RenameAccountToStripeaccount < ActiveRecord::Migration[6.0]
  def up
    rename_column :externalaccounts, :account_id, :stripeaccount_id
    rename_column :idcards,  :account_id,  :stripeaccount_id
    rename_column :payouts,  :account_id,  :stripeaccount_id
    rename_table  :externalaccounts, :stripeexternalaccts
    rename_table  :idcards,  :stripeidcards
    rename_table  :payouts,  :stripepayouts
    rename_table  :subscriptions, :stripesubscriptions
    rename_table  :accounts, :stripeaccounts
  end

  def down
    rename_table  :stripeaccounts, :accounts
    rename_table  :stripesubscriptions, :subscriptions
    rename_table  :stripepayouts,  :payouts
    rename_table  :stripeidcards,  :idcards
    rename_table  :stripeexternalaccts, :externalaccounts
    rename_column :payouts,  :stripeaccount_id, :account_id
    rename_column :idcards,  :stripeaccount_id, :account_id
    rename_column :externalaccounts, :stripeaccount_id, :account_id
  end
end
