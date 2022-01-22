class AddNetaIdToTrades < ActiveRecord::Migration[6.0]
  def up
    add_reference :trades, :neta, type: :integer, foreign_key: true
  end
  
  def down
    remove_index :trades, name: :index_trades_on_neta_id
    remove_column :trades, :neta_id
  end
end
