Fabricator(:flow_action_connect) do
  flow { Fabricate(:flow) }
  action
  data { {
    data_to_send: "Some data to send"
  }}
end
