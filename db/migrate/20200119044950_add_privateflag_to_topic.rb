class AddPrivateflagToTopic < ActiveRecord::Migration[6.0]
  def up
    add_column :topics, :private_flag, :boolean, default: false, null: false
  end

  def down
    remove_column :topics, :private_flag, :boolean
  end
end
