class AddPlayeridIndextoWorldRecord < ActiveRecord::Migration
  def change
    add_index :world_records, [:player_id]
  end
end
