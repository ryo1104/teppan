class CreateEmailrecs < ActiveRecord::Migration[6.0]
  def change
    create_table :emailrecs, id: :integer do |t|
      t.string  :from, null: false
      t.string  :to, null: false
      t.string  :content
      t.timestamps
    end
  end
end
