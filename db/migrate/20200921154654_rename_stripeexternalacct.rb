class RenameStripeexternalacct < ActiveRecord::Migration[6.0]
  def up
    rename_table  :stripeexternalaccts, :stripeexternalaccounts
  end
  
  def down
    rename_table  :stripeexternalaccounts, :stripeexternalaccts
  end
end
