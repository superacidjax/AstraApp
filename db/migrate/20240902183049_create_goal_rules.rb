class CreateGoalRules < ActiveRecord::Migration[7.2]
  def change
    create_table :goal_rules, id: :uuid do |t|
      t.references :goal, null: false, foreign_key: true, type: :uuid
      t.references :rule, null: false, foreign_key: true, type: :uuid
      # the default state is "initial"
      t.integer :state, null: false, default: 1

      t.timestamps
    end
  end
end
