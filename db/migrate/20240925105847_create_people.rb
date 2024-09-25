class CreatePeople < ActiveRecord::Migration[7.2]
  def change
    create_table :people, id: :uuid do |t|
      t.references :account, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
