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

ActiveRecord::Schema.define(version: 20130924000517) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "irradiances", force: true do |t|
    t.text     "direct"
    t.text     "diffuse"
    t.integer  "postcode_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "irradiances", ["postcode_id"], name: "index_irradiances_on_postcode_id", using: :btree

  create_table "panels", force: true do |t|
    t.integer "tilt"
    t.integer "bearing"
    t.decimal "panel_size"
    t.integer "pv_query_id"
  end

  add_index "panels", ["pv_query_id"], name: "index_panels_on_pv_query_id", using: :btree

  create_table "postcodes", force: true do |t|
    t.integer "pcode"
    t.string  "suburb"
    t.string  "state"
    t.decimal "latitude"
    t.decimal "longitude"
  end

  create_table "pv_queries", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "postcode_id"
  end

end
