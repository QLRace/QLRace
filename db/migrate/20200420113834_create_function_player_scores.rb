class CreateFunctionPlayerScores < ActiveRecord::Migration[4.2]
  def change
    create_function :player_scores
  end
end
