class CreateRuleGroupMemberships < ActiveRecord::Migration[7.2]
  def change
    create_table :rule_group_memberships, id: :uuid do |t|
      t.references :parent_group, null: false, foreign_key: { to_table: :rule_groups }, type: :uuid, index: true
      t.references :child_group, null: false, foreign_key: { to_table: :rule_groups }, type: :uuid, index: true
      t.timestamps
    end
    add_index :rule_group_memberships, [ :parent_group_id, :child_group_id ], unique: true, name: 'index_rule_group_memberships_on_parent_and_child'
  end
end
