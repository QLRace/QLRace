class AddGuidToScoresWorldRecords < ActiveRecord::Migration[4.2]
  def change
    add_column :scores, :match_guid, :uuid, null: false
    add_column :world_records, :match_guid, :uuid, null: false
  end
end
