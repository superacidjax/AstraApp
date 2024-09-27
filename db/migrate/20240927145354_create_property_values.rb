class CreatePropertyValues < ActiveRecord::Migration[7.2]
  def change
    create_table :property_values, id: :uuid do |t|
      t.references :event, null: false, foreign_key: true, type: :uuid
      t.references :property, null: false, foreign_key: true, type: :uuid
      t.text :data, null: false

      t.timestamps
    end
    add_index :property_values, [ :event_id, :event_id, :data ]
  end
end
