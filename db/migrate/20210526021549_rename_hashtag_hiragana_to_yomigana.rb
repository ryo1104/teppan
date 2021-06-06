class RenameHashtagHiraganaToYomigana < ActiveRecord::Migration[6.0]
  def up
    rename_column :hashtags,  :hiragana, :yomigana
  end

  def down
    rename_column :hashtags,  :yomigana, :hiragana
  end
end
