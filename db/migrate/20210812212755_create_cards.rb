class CreateCards < ActiveRecord::Migration[6.1]
  def change
    create_table :cards do |t|
      t.string :image
      t.string :name

      t.timestamps
    end
    add_index :cards, :image, unique: true
    add_index :cards, :name, unique: true
  end
end
