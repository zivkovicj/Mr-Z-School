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

ActiveRecord::Schema.define(version: 20170725202419) do

  create_table "consultancies", force: :cascade do |t|
    t.integer  "seminar_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seminar_id"], name: "index_consultancies_on_seminar_id"
  end

  create_table "label_objectives", force: :cascade do |t|
    t.integer  "objective_id"
    t.integer  "label_id"
    t.integer  "quantity"
    t.integer  "point_value"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["label_id", "objective_id"], name: "index_label_objectives_on_label_id_and_objective_id"
    t.index ["label_id"], name: "index_label_objectives_on_label_id"
    t.index ["objective_id"], name: "index_label_objectives_on_objective_id"
  end

  create_table "label_pictures", id: false, force: :cascade do |t|
    t.integer  "label_id"
    t.integer  "picture_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["label_id", "picture_id"], name: "index_label_pictures_on_label_id_and_picture_id"
    t.index ["label_id"], name: "index_label_pictures_on_label_id"
    t.index ["picture_id"], name: "index_label_pictures_on_picture_id"
  end

  create_table "labels", force: :cascade do |t|
    t.string   "name"
    t.string   "extent"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_labels_on_user_id"
  end

  create_table "objective_seminars", force: :cascade do |t|
    t.integer  "seminar_id"
    t.integer  "objective_id"
    t.integer  "priority"
    t.integer  "pretest"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["objective_id", "seminar_id"], name: "index_objective_seminars_on_objective_id_and_seminar_id"
    t.index ["objective_id"], name: "index_objective_seminars_on_objective_id"
    t.index ["seminar_id"], name: "index_objective_seminars_on_seminar_id"
  end

  create_table "objective_students", force: :cascade do |t|
    t.integer  "objective_id"
    t.integer  "user_id"
    t.integer  "points"
    t.integer  "unlocked"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["objective_id", "user_id"], name: "index_objective_students_on_objective_id_and_user_id"
    t.index ["objective_id"], name: "index_objective_students_on_objective_id"
    t.index ["user_id"], name: "index_objective_students_on_user_id"
  end

  create_table "objectives", force: :cascade do |t|
    t.string   "name"
    t.string   "extent"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_objectives_on_user_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "preconditions", force: :cascade do |t|
    t.integer  "mainassign_id"
    t.integer  "preassign_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string   "style"
    t.text     "prompt"
    t.string   "extent"
    t.integer  "user_id"
    t.integer  "label_id"
    t.integer  "picture_id"
    t.text     "correct_answers"
    t.string   "choice_0"
    t.string   "choice_1"
    t.string   "choice_2"
    t.string   "choice_3"
    t.string   "choice_4"
    t.string   "choice_5"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["label_id"], name: "index_questions_on_label_id"
    t.index ["picture_id"], name: "index_questions_on_picture_id"
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "objective_id"
    t.integer  "total_score"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["objective_id"], name: "index_quizzes_on_objective_id"
    t.index ["user_id"], name: "index_quizzes_on_user_id"
  end

  create_table "ripostes", force: :cascade do |t|
    t.integer  "quiz_id"
    t.integer  "question_id"
    t.integer  "tally"
    t.integer  "position"
    t.string   "stud_answer"
    t.integer  "poss"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["question_id"], name: "index_ripostes_on_question_id"
    t.index ["quiz_id"], name: "index_ripostes_on_quiz_id"
  end

  create_table "seminar_students", force: :cascade do |t|
    t.integer  "seminar_id"
    t.integer  "user_id"
    t.integer  "teach_request"
    t.integer  "learn_request"
    t.integer  "pref_request"
    t.boolean  "present"
    t.integer  "consulting_stars"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["seminar_id", "user_id"], name: "index_seminar_students_on_seminar_id_and_user_id"
    t.index ["seminar_id"], name: "index_seminar_students_on_seminar_id"
    t.index ["user_id"], name: "index_seminar_students_on_user_id"
  end

  create_table "seminars", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "consultantThreshold"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["user_id"], name: "index_seminars_on_user_id"
  end

  create_table "student_teams", id: false, force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_student_teams_on_team_id"
    t.index ["user_id", "team_id"], name: "index_student_teams_on_user_id_and_team_id"
    t.index ["user_id"], name: "index_student_teams_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.integer  "consultancy_id"
    t.integer  "objective_id"
    t.integer  "consultant_id"
    t.integer  "bracket"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["consultancy_id"], name: "index_teams_on_consultancy_id"
    t.index ["objective_id"], name: "index_teams_on_objective_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "type"
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "password_digest"
    t.string   "email"
    t.integer  "user_number"
    t.integer  "current_class"
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.boolean  "activated"
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.datetime "last_login"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

end
