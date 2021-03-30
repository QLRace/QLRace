class RemoveIndexScoresOnPlayerId < ActiveRecord::Migration[6.0]
  def change
    remove_index :scores, name: "index_scores_on_player_id"
  end
end
