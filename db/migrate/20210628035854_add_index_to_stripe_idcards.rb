class AddIndexToStripeIdcards < ActiveRecord::Migration[6.0]
  def up
    add_index :stripe_idcards, [:stripe_account_id, :frontback], :unique => true, :name => 'unique_idcard'
  end
  
  def down
    remove_index :stripe_idcards, [:stripe_account_id, :frontback]
  end
end
