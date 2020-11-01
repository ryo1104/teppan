class AddIndexToTrades < ActiveRecord::Migration[6.0]
  def up
    add_index :trades, [:buyer_id, :seller_id, :tradeable_type, :tradeable_id], :unique => true, :name => 'unique_trade'
  end
  
  def down
    remove_index :trades, column: [:buyer_id, :seller_id, :tradeable_type, :tradeable_id]
  end
end
