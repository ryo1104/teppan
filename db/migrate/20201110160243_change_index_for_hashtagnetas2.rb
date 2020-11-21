class ChangeIndexForHashtagnetas2 < ActiveRecord::Migration[6.0]
  def change
    remove_index :hashtag_netas, name: :index_hashtag_netas_on_neta_id
  end
end
