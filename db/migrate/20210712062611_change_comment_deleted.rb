class ChangeCommentDeleted < ActiveRecord::Migration[6.0]
  def up
    add_column  :comments, :deleted_at, :datetime, null: true
    remove_column :comments, :is_deleted
  end
  
  def down
    remove_column  :comments, :deleted_at
    add_column :comments, :is_deleted, :boolean, default: false, null: false
  end
end
