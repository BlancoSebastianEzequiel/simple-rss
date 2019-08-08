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

ActiveRecord::Schema.define(version: 2019_08_07_132257) do

  create_table "articles", force: :cascade do |t|
    t.string "title", null: false
    t.string "link", null: false
    t.integer "feed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link"], name: "index_articles_on_link", unique: true
  end

  create_table "articles_users", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "article_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "read", default: false
    t.index ["article_id"], name: "index_articles_users_on_article_id"
    t.index ["user_id"], name: "index_articles_users_on_user_id"
  end

  create_table "feeds", force: :cascade do |t|
    t.text "url", null: false
    t.text "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url"], name: "index_feeds_on_url", unique: true
  end

  create_table "feeds_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "feed_id", null: false
    t.index ["feed_id", "user_id"], name: "index_feeds_users_on_feed_id_and_user_id"
    t.index ["user_id", "feed_id"], name: "index_feeds_users_on_user_id_and_feed_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "user_name", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_token", default: ""
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["user_name"], name: "index_users_on_user_name", unique: true
  end

end
