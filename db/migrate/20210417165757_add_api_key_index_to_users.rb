class AddApiKeyIndexToUsers < ActiveRecord::Migration[6.1]
  def change
    add_index :users, [:api_key]
  end
end
