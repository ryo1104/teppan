class AddUnregisteredToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column  :users, :unregistered, :boolean, default: false, null: false
  end
  
  def down
    remove_column :users, :unregistered, :boolean
  end
end
