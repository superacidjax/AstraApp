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

ActiveRecord::Schema[7.2].define(version: 2024_09_27_202255) do
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
    t.index ["client_application_id", "person_id"], name: "idx_on_client_application_id_person_id_3f12dbc93a"
    t.index ["client_application_id"], name: "index_client_application_people_on_client_application_id"
    t.index ["person_id"], name: "index_client_application_people_on_person_id"
  end

  create_table "client_application_properties", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "property_id", null: false
    t.uuid "client_application_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_application_id", "property_id"], name: "idx_on_client_application_id_property_id_30d1d917be"
    t.index ["client_application_id"], name: "index_client_application_properties_on_client_application_id"
    t.index ["property_id"], name: "index_client_application_properties_on_property_id"
  end

  create_table "client_application_traits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "trait_id", null: false
    t.uuid "client_application_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_application_id", "trait_id"], name: "idx_on_client_application_id_trait_id_f9598eb181"
    t.index ["client_application_id"], name: "index_client_application_traits_on_client_application_id"
    t.index ["trait_id"], name: "index_client_application_traits_on_trait_id"
  end

  create_table "client_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_client_applications_on_account_id"
  end

  create_table "events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "client_application_id", null: false
    t.text "name", null: false
    t.string "client_user_id", default: "anonymous", null: false
    t.datetime "client_timestamp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_application_id"], name: "index_events_on_client_application_id"
    t.index ["client_user_id", "client_application_id", "name"], name: "idx_on_client_user_id_client_application_id_name_1286f6f45b"
    t.index ["client_user_id"], name: "index_events_on_client_user_id"
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
    t.uuid "person_id", null: false
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
    t.text "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_goals_on_account_id"
  end

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.jsonb "serialized_properties"
    t.text "on_finish"
    t.text "on_success"
    t.text "on_discard"
    t.text "callback_queue_name"
    t.integer "callback_priority"
    t.datetime "enqueued_at"
    t.datetime "discarded_at"
    t.datetime "finished_at"
    t.datetime "jobs_finished_at"
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id", null: false
    t.text "job_class"
    t.text "queue_name"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.text "error"
    t.integer "error_event", limit: 2
    t.text "error_backtrace", array: true
    t.uuid "process_id"
    t.interval "duration"
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
    t.index ["process_id", "created_at"], name: "index_good_job_executions_on_process_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
    t.integer "lock_type", limit: 2
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.uuid "batch_id"
    t.uuid "batch_callback_id"
    t.boolean "is_discrete"
    t.integer "executions_count"
    t.text "job_class"
    t.integer "error_event", limit: 2
    t.text "labels", array: true
    t.uuid "locked_by_id"
    t.datetime "locked_at"
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at_cond", where: "(cron_key IS NOT NULL)"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at_cond", unique: true, where: "(cron_key IS NOT NULL)"
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["labels"], name: "index_good_jobs_on_labels", where: "(labels IS NOT NULL)", using: :gin
    t.index ["locked_by_id"], name: "index_good_jobs_on_locked_by_id", where: "(locked_by_id IS NOT NULL)"
    t.index ["priority", "created_at"], name: "index_good_job_jobs_for_candidate_lookup", where: "(finished_at IS NULL)"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["priority", "scheduled_at"], name: "index_good_jobs_on_priority_scheduled_at_unfinished_unlocked", where: "((finished_at IS NULL) AND (locked_by_id IS NULL))"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "people", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.string "client_user_id", null: false
    t.datetime "client_timestamp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_people_on_account_id"
    t.index ["client_user_id", "account_id"], name: "index_people_on_client_user_id_and_account_id", unique: true
  end

  create_table "properties", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.text "name", null: false
    t.boolean "is_active", default: true, null: false
    t.integer "value_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "is_active"], name: "index_properties_on_account_id_and_is_active"
    t.index ["account_id"], name: "index_properties_on_account_id"
  end

  create_table "property_values", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "event_id", null: false
    t.uuid "property_id", null: false
    t.text "data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "data"], name: "index_property_values_on_event_id_and_event_id_and_data"
    t.index ["event_id"], name: "index_property_values_on_event_id"
    t.index ["property_id"], name: "index_property_values_on_property_id"
  end

  create_table "rules", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.text "name", null: false
    t.jsonb "rule_data", null: false
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
    t.index ["trait_id", "person_id", "data"], name: "index_trait_values_on_trait_id_and_person_id_and_data"
    t.index ["trait_id"], name: "index_trait_values_on_trait_id"
  end

  create_table "traits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.text "name", null: false
    t.integer "value_type", default: 0, null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "is_active"], name: "index_traits_on_account_id_and_is_active"
    t.index ["account_id"], name: "index_traits_on_account_id"
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
  add_foreign_key "client_application_properties", "client_applications"
  add_foreign_key "client_application_properties", "properties"
  add_foreign_key "client_application_traits", "client_applications"
  add_foreign_key "client_application_traits", "traits"
  add_foreign_key "client_applications", "accounts"
  add_foreign_key "events", "client_applications"
  add_foreign_key "flow_actions", "actions"
  add_foreign_key "flow_actions", "flows"
  add_foreign_key "flow_goals", "flows"
  add_foreign_key "flow_goals", "goals"
  add_foreign_key "flow_recipients", "flows"
  add_foreign_key "flow_recipients", "people"
  add_foreign_key "flows", "accounts"
  add_foreign_key "goal_rules", "goals"
  add_foreign_key "goal_rules", "rules"
  add_foreign_key "goals", "accounts"
  add_foreign_key "people", "accounts"
  add_foreign_key "properties", "accounts"
  add_foreign_key "property_values", "events"
  add_foreign_key "property_values", "properties"
  add_foreign_key "rules", "accounts"
  add_foreign_key "trait_values", "people"
  add_foreign_key "trait_values", "traits"
  add_foreign_key "traits", "accounts"
end
