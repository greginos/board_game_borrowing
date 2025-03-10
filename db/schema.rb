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

ActiveRecord::Schema[8.0].define(version: 2025_02_26_204231) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "board_games", force: :cascade do |t|
    t.string "ean"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_link"
    t.integer "min_players"
    t.integer "max_players"
    t.integer "minimum_age"
    t.string "length"
    t.text "description"
  end

  create_table "borrowings", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "game_id"
    t.index ["game_id"], name: "index_borrowings_on_game_id"
    t.index ["user_id"], name: "index_borrowings_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "board_game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "borrowable", default: false, null: false
    t.index ["board_game_id"], name: "index_games_on_board_game_id"
    t.index ["user_id"], name: "index_games_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pseudo"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "borrowings", "games"
  add_foreign_key "borrowings", "users"
  add_foreign_key "games", "board_games"
  add_foreign_key "games", "users"
end
