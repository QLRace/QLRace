class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
    change_column :players, :id , 'bigint'
  end
end
