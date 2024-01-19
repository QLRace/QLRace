class AddPlayeridIndextoWorldRecord < ActiveRecord::Migration[4.2]
  def change
    add_index :world_records, [ :player_id ]
  end
end
