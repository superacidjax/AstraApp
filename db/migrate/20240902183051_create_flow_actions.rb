class CreateFlowActions < ActiveRecord::Migration[7.2]
  def change
    create_table :flow_actions, id: :uuid do |t|
      t.references :action, null: false, foreign_key: true, type: :uuid
      t.references :flow, null: false, foreign_key: true, type: :uuid
      t.string :type, null: false
      t.jsonb :flow_data, null: false, default: {}

      t.timestamps
    end
    add_index :flow_actions, :type
    add_index :flow_actions, :flow_data, using: :gin
  end
end
