class AddDataToGoals < ActiveRecord::Migration[7.2]
  def change
    add_column :goals, :data, :jsonb, null: false
  end
end
