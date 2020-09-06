class RemoveCommentcountFromReviews < ActiveRecord::Migration[6.0]
  def up
    remove_column :reviews, :comments_count, :integer
  end

  def down
    add_column :reviews, :comments_count, :integer
  end
end
