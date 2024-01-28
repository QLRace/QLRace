# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_01_28_190955) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_api_users_on_email", unique: true
  end

  create_table "authentication_tokens", force: :cascade do |t|
    t.string "body"
    t.bigint "api_user_id", null: false
    t.datetime "last_used_at"
    t.integer "expires_in"
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_user_id"], name: "index_authentication_tokens_on_api_user_id"
    t.index ["body"], name: "index_authentication_tokens_on_body"
  end

  create_table "players", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_players_on_name"
  end

  create_table "scores", id: :serial, force: :cascade do |t|
    t.string "map", null: false
    t.integer "mode", null: false
    t.bigint "player_id", null: false
    t.integer "time", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.uuid "match_guid", null: false
    t.integer "checkpoints", array: true
    t.float "speed_start"
    t.float "speed_end"
    t.float "speed_top"
    t.float "speed_average"
    t.bigint "api_user_id"
    t.index ["map", "mode"], name: "index_scores_on_map_and_mode"
    t.index ["player_id", "map", "mode"], name: "index_scores_on_player_id_and_map_and_mode", unique: true
    t.index ["player_id", "mode"], name: "index_scores_on_player_id_and_mode"
  end

  create_table "world_records", id: :serial, force: :cascade do |t|
    t.string "map", null: false
    t.integer "mode", null: false
    t.bigint "player_id", null: false
    t.integer "time", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.uuid "match_guid", null: false
    t.bigint "api_user_id"
    t.index ["map", "mode"], name: "index_world_records_on_map_and_mode", unique: true
    t.index ["player_id"], name: "index_world_records_on_player_id"
  end

  add_foreign_key "authentication_tokens", "api_users"
  add_foreign_key "scores", "players", name: "scores_player_id_fk", on_delete: :cascade
  add_foreign_key "world_records", "players", name: "world_records_player_id_fk", on_delete: :cascade
  create_function :map_scores, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.map_scores(map_name character varying, mode_id integer, scores_limit integer, scores_offset integer DEFAULT 0)
       RETURNS TABLE(rank bigint, id integer, mode integer, player_id bigint, name character varying, "time" integer, checkpoints integer[], speed_start double precision, speed_end double precision, speed_top double precision, speed_average double precision, date timestamp without time zone)
       LANGUAGE plpgsql
      AS $function$
      BEGIN
      	RETURN QUERY SELECT rank() OVER (ORDER BY s.time),
      		s.id, s.mode, s.player_id, p.name, s.time,
            	s.checkpoints, s.speed_start, s.speed_end, s.speed_top,
              s.speed_average, s.updated_at as date
      	FROM scores s
      	INNER JOIN players p
      	ON s.player_id = p.id
      	WHERE s.mode = mode_id AND s.map = map_name
      	ORDER BY rank, date
      	LIMIT scores_limit
      	OFFSET scores_offset;
      END; $function$
  SQL
  create_function :player_scores, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.player_scores(p_id bigint, mode_id integer)
       RETURNS TABLE(id integer, map character varying, mode integer, "time" integer, checkpoints integer[], speed_start double precision, speed_end double precision, speed_top double precision, speed_average double precision, date timestamp without time zone, rank bigint, total_records bigint)
       LANGUAGE plpgsql
      AS $function$
      BEGIN
      	RETURN QUERY SELECT s.id, s.map, s.mode, s.time, s.checkpoints, s.speed_start,
      	s.speed_end, s.speed_top, s.speed_average,
      	s.updated_at AS date, (
      	  SELECT (COUNT(*) + 1) FROM scores s_
      	  WHERE s_.map = s.map AND s_.mode = s.mode AND (s_.time < s.time)
      	) AS rank, (
      	  SELECT COUNT(*) FROM scores s_
      	  WHERE s_.map = s.map AND s_.mode = s.mode
      	) AS total_records
      FROM scores s
      WHERE s.mode = mode_id AND s.player_id = p_id
      ORDER BY map;
      END; $function$
  SQL

end
