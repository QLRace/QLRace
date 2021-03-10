class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :api_key

      t.timestamps null: false
    end
  end
end
