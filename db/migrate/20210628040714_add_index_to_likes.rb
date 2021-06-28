class AddIndexToLikes < ActiveRecord::Migration[6.0]
  def up
    add_index :likes, [:user_id, :likeable_type, :likeable_id], :unique => true, :name => 'unique_like'
  end
  
  def down
    remove_index :likes, column: [:user_id, :likeable_type, :likeable_id]
  end
end
