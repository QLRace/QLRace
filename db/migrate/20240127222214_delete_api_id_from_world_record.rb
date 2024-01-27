class DeleteApiIdFromWorldRecord < ActiveRecord::Migration[7.1]
  def change
    remove_column :world_records, :api_id
  end
end
