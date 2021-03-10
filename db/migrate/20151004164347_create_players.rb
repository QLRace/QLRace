class CreatePlayers < ActiveRecord::Migration[4.2]
  def change
    create_table :players do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
    change_column :players, :id, 'bigint'
  end
end
