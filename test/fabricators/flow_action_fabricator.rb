Fabricator(:flow_action) do
  flow
  action
  type { "FlowAction" }
  flow_data { {} }
end
