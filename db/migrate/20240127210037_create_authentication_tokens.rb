class CreateAuthenticationTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :authentication_tokens do |t|
      t.string :body
      t.references :api_user, null: false, foreign_key: true
      t.datetime :last_used_at
      t.integer :expires_in
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end
    add_index :authentication_tokens, :body
  end
end
