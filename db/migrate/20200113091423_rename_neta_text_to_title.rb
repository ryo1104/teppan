class RenameNetaTextToTitle < ActiveRecord::Migration[6.0]
  def change
    rename_column :netas, :text, :title
  end
end
