Fabricator(:flow_action_wait) do
  flow { Fabricate(:flow) }
  action
  data { {
    wait_in_seconds: 3600
  }}
end
