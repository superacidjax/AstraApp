class CreateTraitValues < ActiveRecord::Migration[7.2]
  def change
    create_table :trait_values, id: :uuid do |t|
      t.references :person, null: false, foreign_key: true, type: :uuid
      t.references :trait, null: false, foreign_key: true, type: :uuid
      t.text :data, null: false

      t.timestamps
    end
    add_index :trait_values, [ :trait_id, :person_id, :data ]
  end
end
