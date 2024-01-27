class AddApiUserIdToScore < ActiveRecord::Migration[7.1]
  def change
    add_column :scores, :api_user_id, :bigint
  end
end
