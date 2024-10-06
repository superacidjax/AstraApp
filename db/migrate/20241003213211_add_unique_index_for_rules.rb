class AddUniqueIndexForRules < ActiveRecord::Migration[7.2]
  def change
    add_index :rules, [ :name, :account_id ], unique: true
  end
end
