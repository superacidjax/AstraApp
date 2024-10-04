class AddPolymorphicAssociationToRules < ActiveRecord::Migration[7.2]
  def change
    add_column :rules, :ruleable_type, :string, null: false
    add_column :rules, :ruleable_id, :uuid, null: false
    add_index :rules, [ :ruleable_type, :ruleable_id ]
  end
end
