class RenameInterestToBookmark < ActiveRecord::Migration[6.0]
  def up
    rename_column :netas,       :interests_count,   :bookmarks_count
    rename_column :topics,      :interests_count,   :bookmarks_count
    rename_column :interests,   :interestable_id,   :bookmarkable_id
    rename_column :interests,   :interestable_type, :bookmarkable_type
    rename_table  :interests,   :bookmarks
  end

  def down
    rename_column :netas,       :bookmarks_count,   :interests_count
    rename_column :topics,      :bookmarks_count,   :interests_count
    rename_table  :bookmarks,   :interests
    rename_column :interests,   :bookmarkable_id,   :interestable_id
    rename_column :interests,   :bookmarkable_type, :interestable_type
  end
end
