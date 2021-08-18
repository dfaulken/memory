class AddSolvedToGameCards < ActiveRecord::Migration[6.1]
  def change
    add_column :game_cards, :solved, :boolean
  end
end
