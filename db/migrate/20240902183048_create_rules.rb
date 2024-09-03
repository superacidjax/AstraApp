class CreateRules < ActiveRecord::Migration[7.2]
  def change
    create_table :rules, id: :uuid do |t|
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false

      t.timestamps
    end
  end
end
