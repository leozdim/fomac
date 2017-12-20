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

ActiveRecord::Schema.define(version: 20171219224136) do

  create_table "addresses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "person_id"
    t.string "street"
    t.string "internal_number"
    t.string "external_number"
    t.string "colony"
    t.string "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_addresses_on_person_id"
  end

  create_table "art_activities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "modality_id"
    t.string "name"
    t.integer "contributions"
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["modality_id"], name: "index_art_activities_on_modality_id"
  end

  create_table "art_forms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "art_forms_projects", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "project_id", null: false
    t.bigint "art_form_id", null: false
    t.index ["project_id", "art_form_id"], name: "index_art_forms_projects_on_project_id_and_art_form_id"
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "key", null: false
    t.boolean "single", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dance_evidences", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "project_id"
    t.string "web"
    t.string "video"
    t.text "image"
    t.text "note"
    t.text "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_dance_evidences_on_project_id"
  end

  create_table "film_evidences", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "project_id"
    t.string "web"
    t.string "video"
    t.string "demo"
    t.string "synopsis"
    t.string "script"
    t.string "plan"
    t.string "letter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_film_evidences_on_project_id"
  end

  create_table "information", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "project_id"
    t.string "name"
    t.text "description"
    t.text "antecedent"
    t.text "justification"
    t.text "general_objective"
    t.text "specific_objective"
    t.text "goals"
    t.text "beneficiary"
    t.text "context"
    t.text "bibliography"
    t.string "activities"
    t.string "spending"
    t.string "funding"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_information_on_project_id"
  end

  create_table "letter_evidences", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "project_id"
    t.string "web"
    t.string "work"
    t.text "cover"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_letter_evidences_on_project_id"
  end

  create_table "modalities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "music_evidences", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "project_id"
    t.string "web"
    t.string "video"
    t.string "audio"
    t.text "score"
    t.text "note"
    t.text "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_music_evidences_on_project_id"
  end

  create_table "people", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "second_last_name"
    t.date "birthdate"
    t.string "home_phone_number"
    t.string "cellphone"
    t.string "birthplace"
    t.string "state"
    t.string "city"
    t.string "nationality"
    t.string "level_study"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id"
    t.index ["project_id"], name: "index_people_on_project_id"
  end

  create_table "person_documents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "person_id"
    t.string "request_letter"
    t.string "birth"
    t.string "address"
    t.string "identification"
    t.string "curp"
    t.string "resume"
    t.string "kardex"
    t.string "agreement_letter"
    t.string "assign_letter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_person_documents_on_person_id"
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "folio"
    t.bigint "user_id"
    t.bigint "category_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_projects_on_category_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "retributions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "project_id"
    t.bigint "modality_id"
    t.bigint "art_activity_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["art_activity_id"], name: "index_retributions_on_art_activity_id"
    t.index ["modality_id"], name: "index_retributions_on_modality_id"
    t.index ["project_id"], name: "index_retributions_on_project_id"
  end

  create_table "theater_evidences", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "project_id"
    t.string "web"
    t.string "video"
    t.string "letter"
    t.string "script"
    t.text "document"
    t.text "image"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_theater_evidences_on_project_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "second_last_name"
    t.string "role"
    t.bigint "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", limit: 150, default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token", limit: 150
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token", limit: 150
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["person_id"], name: "index_users_on_person_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "visual_evidences", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "project_id"
    t.text "catalog"
    t.text "image"
    t.text "note"
    t.text "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_visual_evidences_on_project_id"
  end

  add_foreign_key "addresses", "people"
  add_foreign_key "art_activities", "modalities"
  add_foreign_key "dance_evidences", "projects"
  add_foreign_key "film_evidences", "projects"
  add_foreign_key "information", "projects"
  add_foreign_key "letter_evidences", "projects"
  add_foreign_key "music_evidences", "projects"
  add_foreign_key "people", "projects"
  add_foreign_key "person_documents", "people"
  add_foreign_key "projects", "categories"
  add_foreign_key "projects", "users"
  add_foreign_key "retributions", "art_activities"
  add_foreign_key "retributions", "modalities"
  add_foreign_key "retributions", "projects"
  add_foreign_key "theater_evidences", "projects"
  add_foreign_key "users", "people"
  add_foreign_key "visual_evidences", "projects"
end
