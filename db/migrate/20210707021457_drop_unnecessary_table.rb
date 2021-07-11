class DropUnnecessaryTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :tables
  end
end
