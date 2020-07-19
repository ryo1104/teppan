class AddIsDeletedToComments < ActiveRecord::Migration[6.0]
  def up
    add_column :comments, :is_deleted, :boolean, default: false, null: false
  end

  def down
    remove_column :comments, :is_deleted, :boolean
  end
end
