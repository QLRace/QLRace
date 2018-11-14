class AddUniqueIndexToScores < ActiveRecord::Migration
  def change
    add_index :scores, [:player_id, :map, :mode], :unique => true
  end
end
