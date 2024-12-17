Fabricator(:flow_action_notify) do
  flow { Fabricate(:flow) }
  action
  data { {
    destination: "user@example.com"
  }}
end
