class CreateClientApplicationEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :client_application_events, id: :uuid do |t|
      t.references :client_application, null: false, foreign_key: true, type: :uuid
      t.references :event, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
    add_index :client_application_events, [ :client_application_id, :event_id ]
  end
end
