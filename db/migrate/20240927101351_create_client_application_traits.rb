class CreateClientApplicationTraits < ActiveRecord::Migration[7.2]
  def change
    create_table :client_application_traits, id: :uuid do |t|
      t.references :trait, null: false, foreign_key: true, type: :uuid
      t.references :client_application, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
    add_index :client_application_traits, [ :client_application_id, :trait_id ]
  end
end
