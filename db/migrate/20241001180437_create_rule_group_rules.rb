class CreateRuleGroupRules < ActiveRecord::Migration[7.2]
  def change
    create_table :rule_group_rules, id: :uuid do |t|
      t.references :rule, null: false, foreign_key: true, type: :uuid
      t.references :rule_group, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
