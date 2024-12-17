Fabricator(:flow_action_sms) do
  flow { Fabricate(:flow) }
  action
  data { {
    template_id: UUID7.generate
  }}
end
