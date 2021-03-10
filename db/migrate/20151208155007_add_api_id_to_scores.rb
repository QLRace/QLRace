class AddApiIdToScores < ActiveRecord::Migration[4.2]
  def change
    add_column :scores, :api_id, :integer
  end
end
