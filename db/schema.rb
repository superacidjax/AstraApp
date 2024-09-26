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

ActiveRecord::Schema[7.2].define(version: 2024_09_26_174741) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "account_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_users_on_account_id"
    t.index ["user_id"], name: "index_account_users_on_user_id"
  end

  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "actions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.string "type", null: false
    t.string "name", null: false
    t.jsonb "data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_actions_on_account_id"
    t.index ["data"], name: "index_actions_on_data", using: :gin
    t.index ["type"], name: "index_actions_on_type"
  end

  create_table "client_application_people", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "person_id", null: false
    t.uuid "client_application_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_application_id"], name: "index_client_application_people_on_client_application_id"
    t.index ["person_id"], name: "index_client_application_people_on_person_id"
  end

  create_table "client_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_client_applications_on_account_id"
  end

  create_table "flow_actions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "action_id", null: false
    t.uuid "flow_id", null: false
    t.string "type", null: false
    t.jsonb "flow_data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_id"], name: "index_flow_actions_on_action_id"
    t.index ["flow_data"], name: "index_flow_actions_on_flow_data", using: :gin
    t.index ["flow_id"], name: "index_flow_actions_on_flow_id"
    t.index ["type"], name: "index_flow_actions_on_type"
  end

  create_table "flow_goals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "flow_id", null: false
    t.uuid "goal_id", null: false
    t.decimal "success_rate", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flow_id"], name: "index_flow_goals_on_flow_id"
    t.index ["goal_id"], name: "index_flow_goals_on_goal_id"
  end

  create_table "flow_recipients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "flow_id", null: false
    t.string "person_id", null: false
    t.integer "status", default: 5, null: false
    t.uuid "last_completed_flow_action_id"
    t.boolean "is_goal_achieved", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flow_id"], name: "index_flow_recipients_on_flow_id"
    t.index ["is_goal_achieved"], name: "index_flow_recipients_on_is_goal_achieved"
    t.index ["last_completed_flow_action_id"], name: "index_flow_recipients_on_last_completed_flow_action_id"
    t.index ["person_id"], name: "index_flow_recipients_on_person_id"
    t.index ["status"], name: "index_flow_recipients_on_status"
  end

  create_table "flows", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_flows_on_account_id"
  end

  create_table "goal_rules", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "goal_id", null: false
    t.uuid "rule_id", null: false
    t.integer "state", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["goal_id"], name: "index_goal_rules_on_goal_id"
    t.index ["rule_id"], name: "index_goal_rules_on_rule_id"
  end

  create_table "goals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.decimal "success_rate", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_goals_on_account_id"
  end

  create_table "people", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_people_on_account_id"
  end

  create_table "rules", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_rules_on_account_id"
  end

  create_table "trait_values", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "person_id", null: false
    t.uuid "trait_id", null: false
    t.text "data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_trait_values_on_person_id"
    t.index ["trait_id"], name: "index_trait_values_on_trait_id"
  end

  create_table "traits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.uuid "client_application_id", null: false
    t.text "name", null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_traits_on_account_id"
    t.index ["client_application_id"], name: "index_traits_on_client_application_id"
    t.index ["is_active"], name: "index_traits_on_is_active"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "unique_emails", unique: true
  end

  add_foreign_key "account_users", "accounts"
  add_foreign_key "account_users", "users"
  add_foreign_key "actions", "accounts"
  add_foreign_key "client_application_people", "client_applications"
  add_foreign_key "client_application_people", "people"
  add_foreign_key "client_applications", "accounts"
  add_foreign_key "flow_actions", "actions"
  add_foreign_key "flow_actions", "flows"
  add_foreign_key "flow_goals", "flows"
  add_foreign_key "flow_goals", "goals"
  add_foreign_key "flow_recipients", "flows"
  add_foreign_key "flows", "accounts"
  add_foreign_key "goal_rules", "goals"
  add_foreign_key "goal_rules", "rules"
  add_foreign_key "goals", "accounts"
  add_foreign_key "people", "accounts"
  add_foreign_key "rules", "accounts"
  add_foreign_key "trait_values", "people"
  add_foreign_key "trait_values", "traits"
  add_foreign_key "traits", "accounts"
  add_foreign_key "traits", "client_applications"
end
