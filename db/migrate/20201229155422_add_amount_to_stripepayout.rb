class AddAmountToStripepayout < ActiveRecord::Migration[6.0]
  def up
    add_column  :stripe_payouts, :amount, :integer
  end
  
  def down
    remove_column  :stripe_payouts, :amount
  end
end
