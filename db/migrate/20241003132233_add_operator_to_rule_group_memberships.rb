class AddOperatorToRuleGroupMemberships < ActiveRecord::Migration[7.2]
  def change
    add_column :rule_group_memberships, :operator, :string
  end
end
