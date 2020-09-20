class RemoveAccountPersonalInfo < ActiveRecord::Migration[6.0]
  def up
    remove_column :accounts, :last_name_kanji, :string
    remove_column :accounts, :last_name_kana, :string
    remove_column :accounts, :first_name_kanji, :string
    remove_column :accounts, :first_name_kana, :string
    remove_column :accounts, :gender, :string
    remove_column :accounts, :email, :string
    remove_column :accounts, :birthdate, :date
    remove_column :accounts, :postal_code, :string
    remove_column :accounts, :state, :string
    remove_column :accounts, :city, :string
    remove_column :accounts, :town, :string
    remove_column :accounts, :kanji_line1, :string
    remove_column :accounts, :kanji_line2, :string
    remove_column :accounts, :kana_line1, :string
    remove_column :accounts, :kana_line2, :string
    remove_column :accounts, :phone, :string
    remove_column :accounts, :user_agreement, :boolean
  end

  def down
    add_column :accounts, :last_name_kanji, :string
    add_column :accounts, :last_name_kana, :string
    add_column :accounts, :first_name_kanji, :string
    add_column :accounts, :first_name_kana, :string
    add_column :accounts, :gender, :string
    add_column :accounts, :email, :string
    add_column :accounts, :birthdate, :date
    add_column :accounts, :postal_code, :string
    add_column :accounts, :state, :string
    add_column :accounts, :city, :string
    add_column :accounts, :town, :string
    add_column :accounts, :kanji_line1, :string
    add_column :accounts, :kanji_line2, :string
    add_column :accounts, :kana_line1, :string
    add_column :accounts, :kana_line2, :string
    add_column :accounts, :phone, :string
    add_column :accounts, :user_agreement, :boolean
  end
end
