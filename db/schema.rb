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

ActiveRecord::Schema.define(version: 20161101214946) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "counts", force: :cascade do |t|
    t.string   "key"
    t.integer  "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "roundup_reports", force: :cascade do |t|
    t.text     "tweets"
    t.integer  "roundup_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["roundup_id"], name: "index_roundup_reports_on_roundup_id", using: :btree
  end

  create_table "roundups", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "monitored_accounts"
    t.integer  "frequency",          default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "scheduled_at"
    t.integer  "delayed_job_id"
    t.string   "webhook_endpoint"
    t.string   "email_address"
    t.text     "whitelist"
    t.text     "blacklist"
    t.boolean  "links_only"
    t.boolean  "include_retweets"
    t.index ["user_id"], name: "index_roundups_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "roundup_reports", "roundups"
  add_foreign_key "roundups", "users"
end
