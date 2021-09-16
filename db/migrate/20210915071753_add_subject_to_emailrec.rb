class AddSubjectToEmailrec < ActiveRecord::Migration[6.0]

  def change
    remove_column :emailrecs,  :content
    add_column :emailrecs, :subject, :string
  end
    
end
