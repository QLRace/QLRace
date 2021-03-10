class ChangePlayerIdToBigintOnWorldRecords < ActiveRecord::Migration[4.2]
  def change
    change_column :world_records, :player_id, :bigint
  end
end
