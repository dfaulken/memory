class AddGroupSizeToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :group_size, :integer
  end
end
