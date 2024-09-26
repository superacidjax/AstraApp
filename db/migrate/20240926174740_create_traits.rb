class CreateTraits < ActiveRecord::Migration[7.2]
  def change
    create_table :traits, id: :uuid do |t|
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.references :client_application, null: false, foreign_key: true, type: :uuid
      t.text :name, null: false
      t.integer :value_type, null: false, default: 0
      t.boolean :is_active, default: true, null: false

      t.timestamps
    end
    add_index :traits, :is_active
  end
end
