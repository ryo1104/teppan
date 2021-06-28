class AddIndexToFollows < ActiveRecord::Migration[6.0]
  def up
    add_index :follows, [:user_id, :follower_id], :unique => true, :name => 'unique_follow'
  end
  
  def down
    remove_index :follows, column: [:user_id, :follower_id]
  end
end
