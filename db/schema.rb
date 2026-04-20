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

ActiveRecord::Schema[8.1].define(version: 2026_04_19_192557) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "authors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "biography"
    t.datetime "created_at", null: false
    t.string "first_name", null: false
    t.string "gender"
    t.string "last_name", null: false
    t.datetime "updated_at", null: false
    t.index ["first_name", "last_name"], name: "index_authors_on_first_name_and_last_name", unique: true
  end

  create_table "book_copies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "annotations"
    t.uuid "book_id", null: false
    t.datetime "created_at", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_book_copies_on_book_id"
  end

  create_table "books", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "author_id", null: false
    t.integer "copies_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.uuid "genre_id", null: false
    t.string "isbn", null: false
    t.integer "status", default: 1, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_books_on_author_id"
    t.index ["genre_id"], name: "index_books_on_genre_id"
    t.index ["isbn"], name: "index_books_on_isbn", unique: true
  end

  create_table "genres", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_genres_on_name", unique: true
  end

  create_table "loans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "book_copy_id", null: false
    t.datetime "borrowed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "due_date", null: false
    t.datetime "returned_at"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["book_copy_id"], name: "index_loans_on_book_copy_id"
    t.index ["user_id"], name: "index_loans_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.boolean "enabled", default: true, null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "locked_at"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.string "unlock_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "book_copies", "books"
  add_foreign_key "books", "authors"
  add_foreign_key "books", "genres"
  add_foreign_key "loans", "book_copies"
  add_foreign_key "loans", "users"
end
