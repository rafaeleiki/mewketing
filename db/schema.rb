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

ActiveRecord::Schema.define(version: 20170922204434) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "email_groups", force: :cascade do |t|
    t.bigint "email_id"
    t.bigint "group_id"
    t.index ["email_id"], name: "index_email_groups_on_email_id"
    t.index ["group_id"], name: "index_email_groups_on_group_id"
  end

  create_table "emails", force: :cascade do |t|
    t.datetime "schedule"
    t.string "title"
    t.string "body"
    t.bigint "sender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sender_id"], name: "index_emails_on_sender_id"
  end

  create_table "group_receivers", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "receiver_id"
    t.index ["group_id"], name: "index_group_receivers_on_group_id"
    t.index ["receiver_id"], name: "index_group_receivers_on_receiver_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.boolean "private"
    t.bigint "sender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sender_id"], name: "index_groups_on_sender_id"
  end

  create_table "receivers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.bigint "sender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sender_id"], name: "index_receivers_on_sender_id"
  end

  create_table "senders", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.boolean "admin"
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_senders_on_client_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string "title"
    t.string "body"
    t.bigint "sender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sender_id"], name: "index_templates_on_sender_id"
  end

  add_foreign_key "email_groups", "emails"
  add_foreign_key "email_groups", "groups"
  add_foreign_key "emails", "senders"
  add_foreign_key "group_receivers", "groups"
  add_foreign_key "group_receivers", "receivers"
  add_foreign_key "groups", "senders"
  add_foreign_key "receivers", "senders"
  add_foreign_key "senders", "clients"
  add_foreign_key "templates", "senders"
end
