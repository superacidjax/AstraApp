class CreatePeople < ActiveRecord::Migration[7.2]
  def change
    create_table :people, id: :uuid do |t|
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.uuid :client_user_id, null: false

      t.timestamps
    end
    add_index :people, [ :client_user_id, :account_id ], unique: true
  end
end
