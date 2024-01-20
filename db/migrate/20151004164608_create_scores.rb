class CreateScores < ActiveRecord::Migration[4.2]
  def change
    create_table :scores do |t|
      t.string :map, null: false
      t.integer :mode, null: false
      t.bigint :player_id, null: false
      t.integer :time, null: false

      t.timestamps null: false
    end
    add_index :scores, [:player_id, :map, :mode], unique: true
  end
end
