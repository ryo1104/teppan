class AddPaymentintentToTrades < ActiveRecord::Migration[6.0]
  def up
    add_column    :trades, :stripe_pi_id, :string
    rename_column :trades, :stripe_charge_id, :stripe_ch_id
  end

  def down
    remove_column :trades, :stripe_pi_id, :string
    rename_column :trades, :stripe_ch_id, :stripe_charge_id
  end
end
