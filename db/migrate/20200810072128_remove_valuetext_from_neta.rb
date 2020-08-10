class RemoveValuetextFromNeta < ActiveRecord::Migration[6.0]
  def up
    remove_column :netas, :valuetext, :text
  end

  def down
    add_column :netas, :valuetext, :text
  end
end
