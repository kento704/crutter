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

ActiveRecord::Schema.define(version: 20150225120959) do

  create_table "accounts", force: :cascade do |t|
    t.integer  "group_id",           limit: 4,                  null: false
    t.string   "screen_name",        limit: 255,                null: false
    t.string   "target_user",        limit: 255, default: ""
    t.string   "oauth_token",        limit: 255,                null: false
    t.string   "oauth_token_secret", limit: 255,                null: false
    t.integer  "friends_count",      limit: 4,   default: 0
    t.integer  "followers_count",    limit: 4,   default: 0
    t.string   "description",        limit: 255, default: ""
    t.boolean  "auto_update",        limit: 1,   default: true
    t.boolean  "auto_follow",        limit: 1,   default: true
    t.boolean  "auto_unfollow",      limit: 1,   default: true
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "accounts", ["group_id"], name: "index_accounts_on_group_id", using: :btree
  add_index "accounts", ["screen_name"], name: "index_accounts_on_screen_name", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "display_order", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "power_histories", force: :cascade do |t|
    t.integer  "followers_sum", limit: 4, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

end
