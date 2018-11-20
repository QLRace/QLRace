class AddCheckpointsToScores < ActiveRecord::Migration
  def change
    add_column :scores, :checkpoints, :integer, array:true
  end
end
