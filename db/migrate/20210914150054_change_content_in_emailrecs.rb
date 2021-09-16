class ChangeContentInEmailrecs < ActiveRecord::Migration[6.0]
  def change
    change_column :emailrecs, :content, :text
  end
end
