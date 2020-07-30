class ChangeUserGenderDefault < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :gender, 0
  end
end
