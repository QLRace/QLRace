class AddApiUserIdToWorldRecord < ActiveRecord::Migration[7.1]
  def change
    add_column :world_records, :api_user_id, :bigint
  end
end
