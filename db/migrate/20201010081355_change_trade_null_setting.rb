class ChangeTradeNullSetting < ActiveRecord::Migration[6.0]
  def up
    change_column_null :trades, :buyer_id, false, 0
    change_column :trades, :buyer_id, :integer, default: 0
    change_column_null :trades, :seller_id, false, 0
    change_column :trades, :seller_id, :integer, default: 0
    change_column_null :trades, :price, false, 0
    change_column :trades, :price, :integer, default: 0
    change_column_null :trades, :tradeable_id, false, 0
    change_column :trades, :tradeable_id, :integer, default: 0
    change_column_null :trades, :tradeable_type, false, 0
    change_column :trades, :tradeable_type, :string, default: 0
  end
  
  def down
    change_column_null :trades, :buyer_id, true, nil
    change_column :trades, :buyer_id, :integer, default: nil
    change_column_null :trades, :seller_id, true, nil
    change_column :trades, :seller_id, :integer, default: nil
    change_column_null :trades, :price, true, nil
    change_column :trades, :price, :integer, default: nil
    change_column_null :trades, :tradeable_id, true, nil
    change_column :trades, :tradeable_id, :integer, default: nil
    change_column_null :trades, :tradeable_type, true, nil
    change_column :trades, :tradeable_type, :string, default: nil
  end
end
