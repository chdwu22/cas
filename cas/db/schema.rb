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

ActiveRecord::Schema.define(version: 20161125164032) do

  create_table "courses", force: :cascade do |t|
    t.string   "number"
    t.string   "section"
    t.string   "name"
    t.integer  "size"
    t.string   "day"
    t.string   "time"
    t.integer  "year"
    t.string   "semester"
    t.integer  "room_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "number"
    t.integer  "capacity"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "available_time"
  end

  create_table "systemvariables", force: :cascade do |t|
    t.string "name"
    t.string "value"
  end

  create_table "timeslot_users", force: :cascade do |t|
    t.integer "timeslot_id"
    t.integer "user_id"
    t.integer "preference_type"
  end

  create_table "timeslots", force: :cascade do |t|
    t.string   "day"
    t.integer  "from_time"
    t.integer  "to_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "full_name"
    t.boolean  "is_admin"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
