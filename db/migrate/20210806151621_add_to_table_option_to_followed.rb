class AddToTableOptionToFollowed < ActiveRecord::Migration[6.0]
  def change
    remove_index :follows, name: :index_follows_on_followed_id_and_follower_id
    remove_column :follows, :followed_id, :integer
    add_reference :follows, :followed, type: :int, foreign_key: { to_table: :users }
  end
end
