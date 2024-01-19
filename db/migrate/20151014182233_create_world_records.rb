class CreateWorldRecords < ActiveRecord::Migration[4.2]
  def change
    create_table :world_records do |t|
      t.string :map
      t.integer :mode
      t.integer :player_id
      t.integer :time

      t.timestamps null: false
    end
    add_index :world_records, [ :map, :mode ], unique: true
  end
end
