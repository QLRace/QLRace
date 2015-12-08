class AddApiIdToScores < ActiveRecord::Migration
  def change
    add_column :scores, :api_id, :integer
  end
end
