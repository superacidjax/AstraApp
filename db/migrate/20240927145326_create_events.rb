class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events, id: :uuid do |t|
      t.references :client_application, null: false, foreign_key: true, type: :uuid
      t.text :name, null: false
      t.string :client_user_id, null: false, default: "anonymous"
      t.datetime :client_timestamp, null: false

      t.timestamps
    end
    add_index :events, :client_user_id
    add_index :events, [ :client_user_id, :client_application_id, :name ]
  end
end
