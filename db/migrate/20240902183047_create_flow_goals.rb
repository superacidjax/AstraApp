class CreateFlowGoals < ActiveRecord::Migration[7.2]
  def change
    create_table :flow_goals, id: :uuid do |t|
      t.references :flow, null: false, foreign_key: true, type: :uuid
      t.references :goal, null: false, foreign_key: true, type: :uuid
      t.decimal :success_rate, default: 0.00, null: false

      t.timestamps
    end
  end
end
