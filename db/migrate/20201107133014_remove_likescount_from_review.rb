class RemoveLikescountFromReview < ActiveRecord::Migration[6.0]
  def up
    remove_column :reviews, :likes_count, :integer
  end
  
  def down
    add_column :reviews, :likes_count, :integer
  end
end
