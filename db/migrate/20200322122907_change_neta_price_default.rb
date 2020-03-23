class ChangeNetaPriceDefault < ActiveRecord::Migration[6.0]
  def change
    change_column_default :netas, :price, from: nil, to: 0
  end
end
