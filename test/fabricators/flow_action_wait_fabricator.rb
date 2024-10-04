Fabricator(:flow_action_wait) do
  flow { Fabricate(:flow) }
  action
  flow_data { {
    wait_in_seconds: 3600
  }}
end
