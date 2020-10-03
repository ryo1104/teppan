class RenameStripeaccount < ActiveRecord::Migration[6.0]
  def up
    rename_column :stripe_accounts,  :stripe_acct_id, :acct_id
    rename_column :stripe_accounts,  :stripe_status,  :status
    add_column    :stripe_accounts,  :ext_acct_id,  :string
  end

  def down
    remove_column :stripe_accounts,  :ext_acct_id,  :string
    rename_column :stripe_accounts,  :status,  :stripe_status
    rename_column :stripe_accounts,  :acct_id, :stripe_acct_id
  end
end
