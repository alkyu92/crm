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

ActiveRecord::Schema.define(version: 20170809022957) do

  create_table "accounts", force: :cascade do |t|
    t.string   "account_name"
    t.string   "account_type"
    t.string   "website"
    t.text     "description"
    t.string   "phone"
    t.string   "fax"
    t.string   "industry"
    t.integer  "number_of_employee"
    t.string   "billing_street"
    t.string   "billing_city"
    t.string   "billing_state"
    t.string   "billing_postal_code"
    t.string   "billing_country"
    t.string   "shipping_street"
    t.string   "shipping_city"
    t.string   "shipping_state"
    t.string   "shipping_postal_code"
    t.string   "shipping_country"
    t.integer  "user_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "acctimelines", force: :cascade do |t|
    t.string   "tactivity"
    t.string   "nactivity"
    t.string   "action"
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_acctimelines_on_account_id"
    t.index ["user_id"], name: "index_acctimelines_on_user_id"
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
    t.string   "fax"
    t.string   "mailing_street"
    t.string   "mailing_city"
    t.string   "mailing_state"
    t.string   "mailing_postal_code"
    t.string   "mailing_country"
    t.integer  "account_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["account_id"], name: "index_contacts_on_account_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string   "doc_file_name"
    t.string   "doc_content_type"
    t.integer  "doc_file_size"
    t.datetime "doc_updated_at"
    t.integer  "opportunity_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["opportunity_id"], name: "index_documents_on_opportunity_id"
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

  create_table "notes", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "opportunity_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["opportunity_id"], name: "index_notes_on_opportunity_id"
  end

  create_table "opportunities", force: :cascade do |t|
    t.string   "name"
    t.integer  "current_stage"
    t.string   "business_type"
    t.string   "probability"
    t.string   "amount"
    t.text     "description"
    t.text     "contacts"
    t.string   "loss_reason"
    t.date     "close_date"
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["account_id"], name: "index_opportunities_on_account_id"
    t.index ["user_id"], name: "index_opportunities_on_user_id"
  end

  create_table "priorities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stages", force: :cascade do |t|
    t.string   "name"
    t.string   "status",         default: "Waiting", null: false
    t.integer  "opportunity_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
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
