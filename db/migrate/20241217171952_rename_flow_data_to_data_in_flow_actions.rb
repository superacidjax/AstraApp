class RenameFlowDataToDataInFlowActions < ActiveRecord::Migration[8.0]
  def change
    rename_column :flow_actions, :flow_data, :data
  end
end
