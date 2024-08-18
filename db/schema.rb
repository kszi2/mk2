# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_08_18_171613) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string "name", limit: 32, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_courses_on_name", unique: true
  end

  create_table "courseworks", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.string "name", limit: 32, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id", "name"], name: "index_courseworks_on_course_id_and_name", unique: true
    t.index ["course_id"], name: "index_courseworks_on_course_id"
  end

  create_table "groups", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.string "name", limit: 32, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "year", default: "2024-08-18", null: false
    t.integer "semester", default: 1, null: false
    t.date "first_date", null: false
    t.integer "repeat_times", default: 14, null: false
    t.integer "day_difference", default: 7, null: false
    t.index ["course_id", "name", "year", "semester"], name: "index_groups_on_course_id_and_name_and_year_and_semester", unique: true
    t.index ["course_id"], name: "index_groups_on_course_id"
  end

  create_table "groups_students", id: false, force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "group_id", null: false
  end

  create_table "students", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "neptun", limit: 6, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["neptun"], name: "index_students_on_neptun", unique: true
  end

  create_table "templates", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.bigint "course_id"
    t.string "data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_templates_on_course_id"
    t.index ["name"], name: "index_templates_on_name", unique: true
  end

  add_foreign_key "courseworks", "courses"
  add_foreign_key "groups", "courses"
  add_foreign_key "templates", "courses"
end
