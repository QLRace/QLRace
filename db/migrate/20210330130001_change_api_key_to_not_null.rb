class ChangeApiKeyToNotNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null(:users, :api_key, false)
  end
end
