class CreateClientApplicationProperties < ActiveRecord::Migration[7.2]
  def change
    create_table :client_application_properties, id: :uuid do |t|
      t.references :property, null: false, foreign_key: true, type: :uuid
      t.references :client_application, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
    add_index :client_application_properties, [ :client_application_id, :property_id ]
  end
end
