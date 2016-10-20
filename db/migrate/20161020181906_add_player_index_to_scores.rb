class AddPlayerIndexToScores < ActiveRecord::Migration
  def change
    remove_index :scores, name: 'index_scores_on_player_id_and_map_and_mode'
    add_index :scores, [:player_id, :mode]
    add_index :scores, [:map, :mode]
  end
end
