class CreateClientApplications < ActiveRecord::Migration[7.2]
  def change
    create_table :client_applications, id: :uuid do |t|
      t.string :name, null: false
      t.references :account, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
