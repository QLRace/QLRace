class CreateFunctionPlayerScores < ActiveRecord::Migration
  def change
    create_function :player_scores
  end
end
