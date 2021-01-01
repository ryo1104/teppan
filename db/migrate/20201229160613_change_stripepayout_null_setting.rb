class ChangeStripepayoutNullSetting < ActiveRecord::Migration[6.0]
  def up
    change_column_null :stripe_payouts, :amount, false, 0
    change_column :stripe_payouts, :amount, :integer, default: 0
  end
  
  def down
    change_column_null :stripe_payouts, :amount, true, nil
    change_column :stripe_payouts, :amount, :integer, default: nil
  end
end
