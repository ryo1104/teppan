class AddIndexToReviews < ActiveRecord::Migration[6.0]
  def up
    add_index :reviews, [:user_id, :neta_id], :unique => true, :name => 'unique_review'
  end
  
  def down
    remove_index :reviews, column: [:user_id, :neta_id]
  end
end
