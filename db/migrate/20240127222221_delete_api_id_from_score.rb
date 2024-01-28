class DeleteApiIdFromScore < ActiveRecord::Migration[7.1]
  def change
    remove_column :scores, :api_id
  end
end
