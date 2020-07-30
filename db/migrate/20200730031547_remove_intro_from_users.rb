class RemoveIntroFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :introduction, :text
  end
end
