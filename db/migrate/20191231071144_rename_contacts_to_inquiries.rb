class RenameContactsToInquiries < ActiveRecord::Migration[6.0]
  def change
    rename_table :contacts, :inquiries
  end
end
