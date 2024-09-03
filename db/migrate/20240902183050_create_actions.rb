class CreateActions < ActiveRecord::Migration[7.2]
  def change
    create_table :actions, id: :uuid do |t|
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.string :type, null: false
      t.string :name, null: false
      t.jsonb :data, null: false, default: {}

      t.timestamps
    end
    add_index :actions, :type
    add_index :actions, :data, using: :gin
  end
end
