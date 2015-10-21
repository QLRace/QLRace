class AddGuidToScoresWorldRecords < ActiveRecord::Migration
  def change
    add_column :scores, :match_guid, :uuid, null: false
    add_column :world_records, :match_guid, :uuid, null: false
  end
end
