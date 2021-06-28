class AddIndexToTopics < ActiveRecord::Migration[6.0]
  def up
    add_index :topics, :title, :unique => true
  end
  
  def down
    remove_index :topics, :title
  end
end
