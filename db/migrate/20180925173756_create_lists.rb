class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.string :title,	  default: ""
      t.integer :owner_id, index: true

      t.timestamps
    end
  end
end
