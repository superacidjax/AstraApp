Fabricator(:flow_action_sms) do
  flow { Fabricate(:flow) }
  action
  flow_data { {
    template_id: UUID7.generate
  }}
end
