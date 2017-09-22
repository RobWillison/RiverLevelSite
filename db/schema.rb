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

ActiveRecord::Schema.define(version: 20170922171239) do

  create_table "gatherers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
    t.string "results_table"
    t.datetime "last_run"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "predicted_river_levels", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "river_id", null: false
    t.datetime "predict_time", null: false
    t.float "river_level", limit: 24, null: false
    t.integer "prediction_id"
  end

  create_table "predictions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.datetime "created_date"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "river_id"
  end

  create_table "rain_data", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "timestamp"
    t.datetime "time_string"
    t.integer "rain_value"
    t.integer "area_id"
    t.index ["time_string"], name: "idx_time_string"
    t.index ["time_string"], name: "rain_time_string"
    t.index ["timestamp"], name: "idx_timestamp"
  end

  create_table "rain_forecast_data", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "timestamp", null: false
    t.datetime "time_string", null: false
    t.integer "rain_value", null: false
    t.integer "area_id", null: false
    t.integer "source"
    t.index ["time_string", "area_id", "source"], name: "unique_check", unique: true
    t.index ["time_string"], name: "idx_time_string"
    t.index ["time_string"], name: "rain_time_string"
    t.index ["timestamp"], name: "idx_timestamp"
  end

  create_table "river_data", id: :integer, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "timestamp", null: false
    t.datetime "time_string", null: false
    t.string "station", default: "", null: false
    t.float "river_level", limit: 24, null: false
    t.integer "river_id"
    t.index ["time_string"], name: "idx_time_string"
    t.index ["timestamp"], name: "idx_timestamp"
  end

  create_table "rivers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at"
    t.string "name"
    t.float "lat", limit: 53
    t.float "long", limit: 53
    t.string "station"
    t.integer "rain_radar_area_id"
    t.string "level_indicators"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
