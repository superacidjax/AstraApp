Fabricator(:flow_action_notify) do
  flow { Fabricate(:flow) }
  action
  flow_data { {
    destination: "user@example.com"
  }}
end
