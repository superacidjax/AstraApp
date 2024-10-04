class AddOperatorToRuleGroupRules < ActiveRecord::Migration[7.2]
  def change
    add_column :rule_group_rules, :operator, :string
  end
end
