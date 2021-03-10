class AddApiIdToWorldRecords < ActiveRecord::Migration[4.2]
  def change
    add_column :world_records, :api_id, :integer
  end
end
