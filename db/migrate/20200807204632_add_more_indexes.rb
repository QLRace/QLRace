class AddMoreIndexes < ActiveRecord::Migration[5.0]
  def change
    add_index :scores, [:player_id]
    add_index :players, [:name]
  end
end
