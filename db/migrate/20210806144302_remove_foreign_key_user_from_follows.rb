class RemoveForeignKeyUserFromFollows < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :follows, :users
    remove_index :follows, name: :unique_follow
    rename_column :follows,  :user_id, :followed_id
    add_index :follows, :followed_id
    add_index :follows, :follower_id
    add_index :follows, [:followed_id, :follower_id], unique: true
  end
end
