class AddSpinsAndFinishedToGames < ActiveRecord::Migration
  def change
    add_column :games, :spins, :integer, default: 0
    add_column :games, :finished, :boolean, default: false
  end
end
