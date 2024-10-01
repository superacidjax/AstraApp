class CreateProperties < ActiveRecord::Migration[7.2]
  def change
    create_table :properties, id: :uuid do |t|
      t.references :event, null: false, foreign_key: true, type: :uuid
      t.text :name, null: false
      t.boolean :is_active, null: false, default: true
      t.integer :value_type, null: false, default: 0

      t.timestamps
    end
    add_index :properties, [ :event_id, :is_active ]
  end
end
