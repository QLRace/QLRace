class AddSpeedsToScores < ActiveRecord::Migration[4.2]
  def change
    add_column :scores, :speed_start, :float
    add_column :scores, :speed_end, :float
    add_column :scores, :speed_top, :float
    add_column :scores, :speed_average, :float
  end
end
