class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.integer :size
      t.integer :rows
      t.integer :columns

      t.timestamps
    end
  end
end
