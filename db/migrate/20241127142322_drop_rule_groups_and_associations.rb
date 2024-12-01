class DropRuleGroupsAndAssociations < ActiveRecord::Migration[7.2]
  def up
    if table_exists?(:goal_rule_groups) && foreign_key_exists?(:goal_rule_groups, :rule_groups)
      remove_foreign_key :goal_rule_groups, :rule_groups
    end

    if table_exists?(:rule_group_memberships)
      if foreign_key_exists?(:rule_group_memberships, column: :parent_group_id)
        remove_foreign_key :rule_group_memberships, column: :parent_group_id
      end

      if foreign_key_exists?(:rule_group_memberships, column: :child_group_id)
        remove_foreign_key :rule_group_memberships, column: :child_group_id
      end
    end

    if table_exists?(:rule_group_rules)
      if foreign_key_exists?(:rule_group_rules, :rule_groups)
        remove_foreign_key :rule_group_rules, :rule_groups
      end

      if foreign_key_exists?(:rule_group_rules, :rules)
        remove_foreign_key :rule_group_rules, :rules
      end
    end

    if table_exists?(:rule_group_rules)
      remove_index :rule_group_rules, :rule_group_id if index_exists?(:rule_group_rules, :rule_group_id)
      remove_index :rule_group_rules, :rule_id if index_exists?(:rule_group_rules, :rule_id)
    end

    if table_exists?(:rule_group_memberships)
      remove_index :rule_group_memberships, :parent_group_id if index_exists?(:rule_group_memberships, :parent_group_id)
      remove_index :rule_group_memberships, :child_group_id if index_exists?(:rule_group_memberships, :child_group_id)
    end

    if table_exists?(:goal_rule_groups)
      remove_index :goal_rule_groups, :rule_group_id if index_exists?(:goal_rule_groups, :rule_group_id)
    end

    drop_table :rule_group_rules if table_exists?(:rule_group_rules)
    drop_table :rule_group_memberships if table_exists?(:rule_group_memberships)
    drop_table :goal_rule_groups if table_exists?(:goal_rule_groups)

    drop_table :rule_groups if table_exists?(:rule_groups)
  end

  def down
    create_table :rule_groups do |t|
      t.string :name, null: false
      t.references :account, null: false, foreign_key: true
      t.jsonb :data
      t.timestamps
    end

    create_table :goal_rule_groups do |t|
      t.references :goal, null: false, foreign_key: true
      t.references :rule_group, null: false, foreign_key: true
      t.integer :state, null: false
      t.timestamps
    end

    create_table :rule_group_memberships do |t|
      t.references :parent_group, null: false, foreign_key: { to_table: :rule_groups }
      t.references :child_group, null: false, foreign_key: { to_table: :rule_groups }
      t.string :operator
      t.timestamps
    end

    create_table :rule_group_rules do |t|
      t.references :rule_group, null: false, foreign_key: true
      t.references :rule, null: false, foreign_key: true
      t.timestamps
    end

    add_index :rule_group_rules, :rule_group_id
    add_index :rule_group_rules, :rule_id

    add_index :rule_group_memberships, :parent_group_id
    add_index :rule_group_memberships, :child_group_id

    add_index :goal_rule_groups, :rule_group_id
  end
end
