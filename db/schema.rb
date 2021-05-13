# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_02_131306) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "achievement_levels", force: :cascade do |t|
    t.integer "number"
    t.integer "from"
    t.integer "to"
    t.string "name"
    t.string "color"
    t.bigint "achievement_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "second_color"
    t.string "third_color"
    t.index ["achievement_id"], name: "index_achievement_levels_on_achievement_id"
  end

  create_table "achievements", force: :cascade do |t|
    t.string "title", null: false
    t.integer "kind"
    t.string "image"
    t.string "endpoint"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "achievements_roles", force: :cascade do |t|
    t.bigint "achievement_id"
    t.bigint "role_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["achievement_id"], name: "index_achievements_roles_on_achievement_id"
    t.index ["role_id"], name: "index_achievements_roles_on_role_id"
  end

  create_table "answers", force: :cascade do |t|
    t.string "content"
    t.bigint "question_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "commits", force: :cascade do |t|
    t.string "message"
    t.string "uid"
    t.datetime "time"
    t.string "url"
    t.bigint "user_id"
    t.string "project_name"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_commits_on_project_id"
    t.index ["user_id"], name: "index_commits_on_user_id"
  end

  create_table "difficulty_levels", force: :cascade do |t|
    t.string "title"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.boolean "all_day"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "status", default: 0
    t.string "type"
    t.bigint "project_id"
    t.bigint "assignee_id"
    t.index ["assignee_id"], name: "index_events_on_assignee_id"
    t.index ["deleted_at"], name: "index_events_on_deleted_at"
    t.index ["project_id"], name: "index_events_on_project_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "links", force: :cascade do |t|
    t.string "link"
    t.string "kind"
    t.bigint "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_links_on_deleted_at"
    t.index ["user_id"], name: "index_links_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id"
    t.string "text", null: false
    t.integer "importance", default: 2, null: false
    t.datetime "readed_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_notifications_on_deleted_at"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "onboarding_steps", force: :cascade do |t|
    t.bigint "onboarding_id"
    t.bigint "step_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "read", default: false
    t.index ["onboarding_id"], name: "index_onboarding_steps_on_onboarding_id"
    t.index ["step_id"], name: "index_onboarding_steps_on_step_id"
  end

  create_table "onboardings", force: :cascade do |t|
    t.string "gmail_login"
    t.string "gmail_password"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_url"
    t.string "raw_invitation_token"
    t.index ["user_id"], name: "index_onboardings_on_user_id"
  end

  create_table "permission_subjects", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.string "description"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "subject"
    t.string "action"
    t.string "description"
  end

  create_table "permissions_roles", force: :cascade do |t|
    t.bigint "permission_id"
    t.bigint "role_id"
    t.index ["permission_id"], name: "index_permissions_roles_on_permission_id"
    t.index ["role_id"], name: "index_permissions_roles_on_role_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.boolean "paid", default: false, null: false
    t.integer "platform"
    t.bigint "manager_id"
    t.boolean "archived", default: false, null: false
    t.string "title"
    t.index ["manager_id"], name: "index_projects_on_manager_id"
    t.index ["project_id"], name: "index_projects_on_project_id", unique: true
  end

  create_table "questions", force: :cascade do |t|
    t.string "title"
    t.bigint "section_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["section_id"], name: "index_questions_on_section_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "text", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.index ["project_id"], name: "index_reports_on_project_id"
  end

  create_table "role_steps", force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "step_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["role_id"], name: "index_role_steps_on_role_id"
    t.index ["step_id"], name: "index_role_steps_on_step_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "roles_users", force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "user_id"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_roles_users_on_deleted_at"
    t.index ["role_id"], name: "index_roles_users_on_role_id"
    t.index ["user_id"], name: "index_roles_users_on_user_id"
  end

  create_table "sections", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "image"
  end

  create_table "skill_types", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skills", force: :cascade do |t|
    t.string "title"
    t.bigint "difficulty_level_id"
    t.text "variants"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "skill_type_id"
    t.index ["skill_type_id"], name: "index_skills_on_skill_type_id"
  end

  create_table "skills_updates", force: :cascade do |t|
    t.bigint "users_skill_id"
    t.integer "level"
    t.boolean "approved"
    t.bigint "approver_id"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "steps", force: :cascade do |t|
    t.string "name"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default"
    t.string "kind"
    t.string "description"
  end

  create_table "timings", force: :cascade do |t|
    t.time "start"
    t.time "end"
    t.boolean "flexible", default: false, null: false
  end

  create_table "update_projects", force: :cascade do |t|
    t.bigint "update_id"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_update_projects_on_deleted_at"
    t.index ["project_id"], name: "index_update_projects_on_project_id"
    t.index ["update_id"], name: "index_update_projects_on_update_id"
  end

  create_table "updates", force: :cascade do |t|
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "made"
    t.string "planning"
    t.string "issues"
    t.integer "user_id"
    t.datetime "deleted_at"
    t.string "slack_ts"
    t.string "discord_message_id"
    t.index ["deleted_at"], name: "index_updates_on_deleted_at"
    t.index ["user_id", "date"], name: "index_updates_on_user_id_and_date", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "jti", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "", null: false
    t.string "surname", default: "", null: false
    t.date "birthday"
    t.date "employment_at"
    t.integer "sex"
    t.string "skype"
    t.string "phone"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.string "avatar"
    t.string "slack_id"
    t.string "temp_integration_token"
    t.string "slack_token"
    t.string "temp_referer"
    t.string "timedoctor_token"
    t.string "timedoctor_refresh_token"
    t.integer "timedoctor_company_id"
    t.integer "timedoctor_user_id"
    t.boolean "registration_finished", default: false
    t.boolean "notify_update", default: true
    t.datetime "deleted_at"
    t.integer "timing_id"
    t.string "slack_team_id"
    t.string "slack_name"
    t.string "discord_token"
    t.string "discord_refresh_token"
    t.string "discord_id"
    t.string "discord_username"
    t.string "discord_dm_id"
    t.boolean "discord_notify_update", default: true
    t.integer "english_level", default: 0
    t.integer "working_hours", default: 35
    t.integer "vacation_days_initial", default: 0
    t.date "last_english_update"
    t.integer "vacation_days_used", default: 0
    t.text "about"
    t.integer "consecutive_updates_count", default: 0
    t.boolean "vacation_notifier_disabled", default: false
    t.string "name_cyrillic"
    t.string "surname_cyrillic"
    t.string "discord_name"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "users_achievements", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "achievement_id"
    t.integer "level", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "score", default: 0
    t.integer "best_result", default: 0
    t.boolean "favorite", default: false
    t.index ["achievement_id"], name: "index_users_achievements_on_achievement_id"
    t.index ["user_id"], name: "index_users_achievements_on_user_id"
  end

  create_table "users_skills", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "skill_id"
    t.integer "level", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "worklogs", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "length"
    t.integer "task_id"
    t.string "task_name"
    t.string "task_url"
    t.date "date"
    t.integer "source"
    t.integer "project_id", default: 0, null: false
    t.datetime "deleted_at"
    t.integer "source_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.index ["deleted_at"], name: "index_worklogs_on_deleted_at"
    t.index ["user_id"], name: "index_worklogs_on_user_id"
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "commits", "projects"
  add_foreign_key "commits", "users"
  add_foreign_key "events", "projects"
  add_foreign_key "events", "users", column: "assignee_id"
  add_foreign_key "onboardings", "users"
  add_foreign_key "permissions_roles", "permissions"
  add_foreign_key "permissions_roles", "roles"
  add_foreign_key "projects", "users", column: "manager_id"
  add_foreign_key "questions", "sections"
  add_foreign_key "update_projects", "projects"
  add_foreign_key "update_projects", "updates"
  add_foreign_key "users", "timings"
end
