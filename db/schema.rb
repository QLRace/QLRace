# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200420112137) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "players", id: :bigserial, force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scores", force: :cascade do |t|
    t.string   "map",                     null: false
    t.integer  "mode",                    null: false
    t.integer  "player_id",     limit: 8, null: false
    t.integer  "time",                    null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.uuid     "match_guid",              null: false
    t.integer  "api_id"
    t.integer  "checkpoints",                          array: true
    t.float    "speed_start"
    t.float    "speed_end"
    t.float    "speed_top"
    t.float    "speed_average"
  end

  add_index "scores", ["map", "mode"], name: "index_scores_on_map_and_mode", using: :btree
  add_index "scores", ["player_id", "map", "mode"], name: "index_scores_on_player_id_and_map_and_mode", unique: true, using: :btree
  add_index "scores", ["player_id", "mode"], name: "index_scores_on_player_id_and_mode", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "api_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "world_records", force: :cascade do |t|
    t.string   "map",                  null: false
    t.integer  "mode",                 null: false
    t.integer  "player_id",  limit: 8, null: false
    t.integer  "time",                 null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.uuid     "match_guid",           null: false
    t.integer  "api_id"
  end

  add_index "world_records", ["map", "mode"], name: "index_world_records_on_map_and_mode", unique: true, using: :btree
  add_index "world_records", ["player_id"], name: "index_world_records_on_player_id", using: :btree

  add_foreign_key "scores", "players", name: "scores_player_id_fk", on_delete: :cascade
  add_foreign_key "world_records", "players", name: "world_records_player_id_fk", on_delete: :cascade

  create_function :map_scores, sql_definition: <<-SQL
      CREATE OR REPLACE FUNCTION public.map_scores(map_name character varying, mode_id integer, scores_limit integer)
       RETURNS TABLE(rank bigint, id integer, mode integer, player_id bigint, name character varying, "time" integer, checkpoints integer[], speed_start double precision, speed_end double precision, speed_top double precision, speed_average double precision, match_guid uuid, date timestamp without time zone)
       LANGUAGE plpgsql
      AS $function$
      BEGIN
      	RETURN QUERY SELECT rank() OVER (ORDER BY s.time),
      		s.id, s.mode, s.player_id, p.name, s.time,
            	s.checkpoints, s.speed_start, s.speed_end, s.speed_top,
              s.speed_average, s.match_guid, s.updated_at as date
      	FROM scores s
      	INNER JOIN players p
      	ON s.player_id = p.id
      	WHERE s.mode = mode_id AND s.map = map_name
      	ORDER BY rank, date
      	LIMIT scores_limit;
      END; $function$
  SQL
end
