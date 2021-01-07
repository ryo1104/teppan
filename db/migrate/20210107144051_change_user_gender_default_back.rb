class ChangeUserGenderDefaultBack < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :gender, nil
  end
end
