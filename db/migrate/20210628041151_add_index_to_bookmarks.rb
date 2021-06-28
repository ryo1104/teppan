class AddIndexToBookmarks < ActiveRecord::Migration[6.0]
  def up
    add_index :bookmarks, [:user_id, :bookmarkable_type, :bookmarkable_id], :unique => true, :name => 'unique_bookmark'
  end
  
  def down
    remove_index :bookmarks, column: [:user_id, :bookmarkable_type, :bookmarkable_id]
  end
end
