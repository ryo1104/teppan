class RenameBankAndBranchHira < ActiveRecord::Migration[6.0]
  def change
    rename_column :banks, :name_kana, :namekana
    rename_column :banks, :name_hira, :namehira
    rename_column :banks, :name_en, :roma
    rename_column :branches, :name_kana, :namekana
    rename_column :branches, :name_hira, :namehira
    rename_column :branches, :name_en, :roma
  end
end
