class AddIndexToViolations < ActiveRecord::Migration[6.0]
  def up
    add_index :violations, [:user_id, :reporter_id], :unique => true, :name => 'unique_violation'
  end
  
  def down
    remove_index :violations, column: [:user_id, :reporter_id]
  end
end
