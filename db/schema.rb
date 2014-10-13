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

ActiveRecord::Schema.define(version: 20141013093952) do

  create_table "lottery649s", id: false, force: true do |t|
    t.string   "term",         null: false
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

end
