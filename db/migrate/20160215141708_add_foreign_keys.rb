class AddForeignKeys < ActiveRecord::Migration[4.2]
  def change
    add_foreign_key 'scores', 'players',
                    name: 'scores_player_id_fk', on_delete: :cascade
    add_foreign_key 'world_records', 'players',
                    name: 'world_records_player_id_fk', on_delete: :cascade
  end
end
