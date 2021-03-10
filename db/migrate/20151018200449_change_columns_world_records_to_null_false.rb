class ChangeColumnsWorldRecordsToNullFalse < ActiveRecord::Migration[4.2]
  def change
    change_column_null :world_records, :map, false
    change_column_null :world_records, :mode, false
    change_column_null :world_records, :player_id, false
    change_column_null :world_records, :time, false
  end
end
