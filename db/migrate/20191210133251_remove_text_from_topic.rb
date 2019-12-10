class RemoveTextFromTopic < ActiveRecord::Migration[6.0]
  def change
    remove_column :topics, :text, :text
  end
end
