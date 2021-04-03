class AddProfileImageUrlToUser < ActiveRecord::Migration[6.0]
  def up
    add_column  :users, :avatar_img_url, :string
  end
  
  def down
    remove_column  :users, :avatar_img_url
  end
end
