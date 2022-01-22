class AddUniqueIndexOnTrades < ActiveRecord::Migration[6.0]
  def change
    remove_index :trades, name: :index_trades_on_neta_id
    add_index :trades, [:buyer_id, :seller_id, :neta_id], :unique => true, :name => 'unique_trade'
  end
end
