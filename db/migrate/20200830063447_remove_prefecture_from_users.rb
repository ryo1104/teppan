class RemovePrefectureFromUsers < ActiveRecord::Migration[6.0]
  def up
    remove_column :users, :prefecture_code, :integer
  end

  def down
    add_column :users, :prefecture_code, :integer
  end
end
