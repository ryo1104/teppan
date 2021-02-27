class AddFileUrlToTopic < ActiveRecord::Migration[6.0]
  def up
    add_column  :topics, :header_img_url, :string
  end
  
  def down
    remove_column  :topics, :header_img_url
  end
end
