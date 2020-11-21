class AddDefaultToViolationBlock < ActiveRecord::Migration[6.0]
  def up
    change_column :violations, :block, :boolean, null: false, default: 0
    change_column :violations, :reporter_id, :integer, null: false, default: 0
  end

  def down
    change_column :violations, :block, :boolean, null: true, default: 0
    change_column :violations, :reporter_id, :integer, null: true, default: 0
  end
end
