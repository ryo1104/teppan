class AddHiraganaToHashtag < ActiveRecord::Migration[6.0]
  def change
    add_column :hashtags, :hiragana, :string
  end
end
