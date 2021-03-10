class AddCheckpointsToScores < ActiveRecord::Migration[4.2]
  def change
    add_column :scores, :checkpoints, :integer, array:true
  end
end
