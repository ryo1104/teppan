class ChangeIndexForHashtagnetas < ActiveRecord::Migration[6.0]
  def change
    remove_index :hashtag_netas, name: :index_hashtag_netas_on_hashtag_id
    add_index :hashtag_netas, [:neta_id, :hashtag_id], unique: true
  end
end
