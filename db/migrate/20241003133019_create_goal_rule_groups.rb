class CreateGoalRuleGroups < ActiveRecord::Migration[7.2]
  def change
    create_table :goal_rule_groups, id: :uuid do |t|
      t.references :goal, null: false, foreign_key: true, type: :uuid
      t.references :rule_group, null: false, foreign_key: true, type: :uuid
      t.integer :state, null: false, default: 1

      t.timestamps
    end
    add_index :goal_rule_groups, :state
  end
end
