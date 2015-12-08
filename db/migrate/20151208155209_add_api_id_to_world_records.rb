class AddApiIdToWorldRecords < ActiveRecord::Migration
  def change
    add_column :world_records, :api_id, :integer
  end
end
