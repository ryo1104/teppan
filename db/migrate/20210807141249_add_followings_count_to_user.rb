class AddFollowingsCountToUser < ActiveRecord::Migration[6.0]
  def up
    rename_column :users,  :follows_count, :followers_count
    add_column :users, :followings_count, :integer, default: 0, null: false
  end

  def down
    rename_column :users, :followers_count, :follows_count
    remove_column :users, :followings_count, :integer, default: 0, null: false
  end
end
