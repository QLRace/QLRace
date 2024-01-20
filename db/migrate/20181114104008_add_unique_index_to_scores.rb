class AddUniqueIndexToScores < ActiveRecord::Migration[4.2]
  def change
    add_index :scores, [:player_id, :map, :mode], unique: true
  end
end
