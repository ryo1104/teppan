class RemoveIndexFromTrades < ActiveRecord::Migration[6.0]
  def up
    remove_index :trades, name: :unique_trade
  end
  
  def down
    add_index :trades, [:buyer_id, :seller_id, :tradeable_type, :tradeable_id], :unique => true, :name => 'unique_trade'
  end
end
