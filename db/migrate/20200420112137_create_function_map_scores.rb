class CreateFunctionMapScores < ActiveRecord::Migration[4.2]
  def change
    create_function :map_scores
  end
end
