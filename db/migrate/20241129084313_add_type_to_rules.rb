class AddTypeToRules < ActiveRecord::Migration[7.2]
  def change
    add_column :rules, :type, :string, null: false
    add_index :rules, :type
  end
end
