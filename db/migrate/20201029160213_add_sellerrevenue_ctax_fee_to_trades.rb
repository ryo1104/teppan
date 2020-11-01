class AddSellerrevenueCtaxFeeToTrades < ActiveRecord::Migration[6.0]

  def up
    add_column  :trades, :seller_revenue, :integer
    add_column  :trades, :fee, :integer
    add_column  :trades, :c_tax, :integer
  end

  def down
    remove_column  :trades, :seller_revenue
    remove_column  :trades, :fee
    remove_column  :trades, :c_tax
  end

end
