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

ActiveRecord::Schema.define(version: 20170801043131) do

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "activities", force: :cascade do |t|
    t.datetime "due_date"
    t.string   "subject"
    t.text     "comments"
    t.integer  "priority_id", default: 1, null: false
    t.integer  "status_id",   default: 1, null: false
    t.text     "assigned_to"
    t.text     "related_to"
    t.integer  "user_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "calls", force: :cascade do |t|
    t.text     "description"
    t.integer  "duration"
    t.datetime "call_datetime"
    t.boolean  "complete",       default: false
    t.integer  "opportunity_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["opportunity_id"], name: "index_calls_on_opportunity_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "name"
    t.string   "title"
    t.string   "department"
    t.string   "email"
    t.string   "phone"
    t.string   "address"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "documents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.text     "description"
    t.date     "event_date"
    t.boolean  "complete",       default: false
    t.integer  "opportunity_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["opportunity_id"], name: "index_events_on_opportunity_id"
  end

  create_table "opportunities", force: :cascade do |t|
    t.string   "name"
    t.integer  "stage_id"
    t.integer  "account_id"
    t.string   "business_type"
    t.string   "probability"
    t.string   "amount"
    t.text     "description"
    t.string   "loss_reason"
    t.date     "close_date"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["user_id"], name: "index_opportunities_on_user_id"
  end

  create_table "priorities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stages", force: :cascade do |t|
    t.string   "name"
    t.boolean  "complete",       default: false
    t.integer  "opportunity_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["opportunity_id"], name: "index_stages_on_opportunity_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.text     "description"
    t.date     "due_date"
    t.boolean  "complete",       default: false
    t.integer  "opportunity_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["opportunity_id"], name: "index_tasks_on_opportunity_id"
  end

  create_table "timelines", force: :cascade do |t|
    t.string   "tactivity"
    t.string   "nactivity"
    t.string   "action"
    t.integer  "opportunity_id"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["opportunity_id"], name: "index_timelines_on_opportunity_id"
    t.index ["user_id"], name: "index_timelines_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "phone"
    t.string   "title"
    t.string   "address"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
