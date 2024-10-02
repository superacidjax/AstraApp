class CreateRuleGroups < ActiveRecord::Migration[7.2]
  def change
    create_table :rule_groups, id: :uuid do |t|
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.text :name, null: false
      t.jsonb :data, null: false, default: "{}"

      t.timestamps
    end
  end
end
