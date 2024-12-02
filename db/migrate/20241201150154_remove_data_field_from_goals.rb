class RemoveDataFieldFromGoals < ActiveRecord::Migration[7.2]
  def change
    remove_column :goals, :data, :jsonb
  end
end
