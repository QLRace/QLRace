class ChangePlayerIdToBigintOnWorldRecords < ActiveRecord::Migration
  def change
    change_column :world_records, :player_id, :bigint
  end
end
