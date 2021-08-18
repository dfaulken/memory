class RemoveSizeFromGames < ActiveRecord::Migration[6.1]
  def change
    remove_column :games, :size, :integer
  end
end
