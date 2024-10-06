class RenameRuleDataToDataInRules < ActiveRecord::Migration[7.2]
  def change
    rename_column :rules, :rule_data, :data
  end
end
