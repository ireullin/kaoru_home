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

ActiveRecord::Schema.define(version: 20141126075238) do

  create_table "food_menus", id: false, force: true do |t|
    t.string   "food_type"
    t.text     "context"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "login_histories", id: false, force: true do |t|
    t.string   "ip"
    t.string   "path"
    t.text     "agent"
    t.datetime "created_at"
  end

  create_table "lottery649s", primary_key: "term", force: true do |t|
    t.integer  "no1",          null: false
    t.integer  "no2",          null: false
    t.integer  "no3",          null: false
    t.integer  "no4",          null: false
    t.integer  "no5",          null: false
    t.integer  "no6",          null: false
    t.integer  "special",      null: false
    t.date     "announced_at", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lottery649s", ["term"], name: "sqlite_autoindex_lottery649s_1", unique: true

  create_table "lottery_statistics", id: false, force: true do |t|
    t.string   "statistic_type"
    t.text     "context"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "money_note_histories", force: true do |t|
    t.string   "category"
    t.string   "item"
    t.string   "comment"
    t.float    "price"
    t.date     "expended_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "money_note_items", id: false, force: true do |t|
    t.text     "items"
    t.datetime "updated_at"
  end

  create_table "photo_albums", id: false, force: true do |t|
    t.string   "path"
    t.string   "name"
    t.string   "yahoo_account"
    t.string   "api_key"
    t.string   "shared_secret"
    t.string   "photoset_id"
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photo_albums", ["path"], name: "index_photo_albums_on_path", unique: true

  create_table "superlottos", primary_key: "term", force: true do |t|
    t.integer  "no1",          null: false
    t.integer  "no2",          null: false
    t.integer  "no3",          null: false
    t.integer  "no4",          null: false
    t.integer  "no5",          null: false
    t.integer  "no6",          null: false
    t.integer  "special",      null: false
    t.date     "announced_at", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "superlottos", ["term"], name: "sqlite_autoindex_superlottos_1", unique: true

  create_table "weathers", id: false, force: true do |t|
    t.date     "weather_date"
    t.string   "des"
    t.float    "max"
    t.float    "min"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city"
  end

end
