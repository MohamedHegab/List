class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.string :title,	   default: ""
      t.text :description
      t.integer :list_id,  index: true
      t.integer :owner_id, index: true

      t.timestamps
    end
  end
end
