class CreateClientApplicationPeople < ActiveRecord::Migration[7.2]
  def change
    create_table :client_application_people, id: :uuid do |t|
      t.references :person, null: false, foreign_key: true, type: :uuid
      t.references :client_application, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
