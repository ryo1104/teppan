class RemovePolymorphFromTradeModel < ActiveRecord::Migration[6.0]
  def up
    remove_columns :trades, :tradetype, :tradestatus, :tradeable_id, :tradeable_type
  end
  
  def down
    add_column :trades, :tradetype, :string
    add_column :trades, :tradestatus, :string
    add_column :trades, :tradeable_id, :integer, default: 0, null: false
    add_column :trades, :tradeable_type, :string
  end
end
