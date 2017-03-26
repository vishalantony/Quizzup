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

ActiveRecord::Schema.define(version: 20170324113244) do

  create_table "choices", force: :cascade do |t|
    t.string   "choice"
    t.integer  "question_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["question_id"], name: "index_choices_on_question_id"
  end

  create_table "question_types", force: :cascade do |t|
    t.string   "typename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.text     "question"
    t.integer  "question_type_id"
    t.string   "answer"
    t.integer  "topic_id"
    t.integer  "creator_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "draft",            default: true
    t.boolean  "approved",         default: false
    t.boolean  "disapproved",      default: false
    t.index ["creator_id"], name: "index_questions_on_creator_id"
    t.index ["topic_id"], name: "index_questions_on_topic_id"
  end

  create_table "questions_quizzes", id: false, force: :cascade do |t|
    t.integer "question_id"
    t.integer "quiz_id"
  end

  create_table "quiz_questions", force: :cascade do |t|
    t.integer  "marks"
    t.string   "user_answer"
    t.integer  "quiz_id"
    t.integer  "question_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["question_id"], name: "index_quiz_questions_on_question_id"
    t.index ["quiz_id", "question_id"], name: "index_quiz_questions_on_quiz_id_and_question_id", unique: true
    t.index ["quiz_id"], name: "index_quiz_questions_on_quiz_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.integer  "taker_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "submitted",  default: false
    t.index ["name"], name: "index_quizzes_on_name"
    t.index ["taker_id"], name: "index_quizzes_on_taker_id"
  end

  create_table "topic_followers", force: :cascade do |t|
    t.integer  "followed_topic_id"
    t.integer  "follower_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["followed_topic_id", "follower_id"], name: "index_topic_followers_on_followed_topic_id_and_follower_id", unique: true
    t.index ["followed_topic_id"], name: "index_topic_followers_on_followed_topic_id"
    t.index ["follower_id"], name: "index_topic_followers_on_follower_id"
  end

  create_table "topic_relationships", force: :cascade do |t|
    t.integer  "parent_id"
    t.integer  "subtopic_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["parent_id", "subtopic_id"], name: "index_topic_relationships_on_parent_id_and_subtopic_id", unique: true
    t.index ["parent_id"], name: "index_topic_relationships_on_parent_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.text     "about"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_topics_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
