class CreatessFlowRecipients < ActiveRecord::Migration[7.2]
  def change
    create_table :flow_recipients, id: :uuid do |t|
      t.references :flow, null: false, foreign_key: true, type: :uuid
      # t.references :person, null: false, foreign_key: true, type: :uuid
      t.integer :status, default: 5, null: false
      t.uuid :last_completed_flow_action_id
      t.boolean :is_goal_achieved, default: false, null: false

      t.timestamps
    end
    add_index :flow_recipients, :status
    add_index :flow_recipients, :last_completed_flow_action_id
    add_index :flow_recipients, :is_goal_achieved
  end
end
