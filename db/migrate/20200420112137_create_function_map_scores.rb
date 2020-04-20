class CreateFunctionMapScores < ActiveRecord::Migration
  def change
    create_function :map_scores
  end
end
