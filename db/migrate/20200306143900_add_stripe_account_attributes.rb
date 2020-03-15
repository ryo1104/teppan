class AddStripeAccountAttributes < ActiveRecord::Migration[6.0]

  def up
    add_column :accounts, :last_name_kanji,   :string, null: false
    add_column :accounts, :last_name_kana,    :string, null: false
    add_column :accounts, :first_name_kanji,  :string, null: false
    add_column :accounts, :first_name_kana,   :string, null: false
    add_column :accounts, :gender,            :string, null: false
    add_column :accounts, :email,             :string, null: false
    add_column :accounts, :birthdate,         :date, null: false
    add_column :accounts, :postal_code,       :string, null: false
    add_column :accounts, :state,             :string, null: false
    add_column :accounts, :city,              :string, null: false
    add_column :accounts, :town,              :string, null: false
    add_column :accounts, :kanji_line1,       :string, null: false
    add_column :accounts, :kanji_line2,       :string, null: false
    add_column :accounts, :kana_line1,        :string, null: false
    add_column :accounts, :kana_line2,        :string, null: false
    add_column :accounts, :phone,             :string, null: false
    add_column :accounts, :user_agreement,    :boolean, default: false, null: false
  end

  def down
    remove_column :accounts, :last_name_kanji,   :string, null: false
    remove_column :accounts, :last_name_kana,    :string, null: false
    remove_column :accounts, :first_name_kanji,  :string, null: false
    remove_column :accounts, :first_name_kana,   :string, null: false
    remove_column :accounts, :gender,            :string, null: false
    remove_column :accounts, :email,             :string, null: false
    remove_column :accounts, :birthdate,         :date, null: false
    remove_column :accounts, :postal_code,       :string, null: false
    remove_column :accounts, :state,             :string, null: false
    remove_column :accounts, :city,              :string, null: false
    remove_column :accounts, :town,              :string, null: false
    remove_column :accounts, :kanji_line1,       :string, null: false
    remove_column :accounts, :kanji_line2,       :string, null: false
    remove_column :accounts, :kana_line1,        :string, null: false
    remove_column :accounts, :kana_line2,        :string, null: false
    remove_column :accounts, :phone,             :string, null: false
    remove_column :accounts, :user_agreement,    :boolean, default: false, null: false
  end
  
end
