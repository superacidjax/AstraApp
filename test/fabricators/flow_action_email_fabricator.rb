Fabricator(:flow_action_email) do
  flow { Fabricate(:flow) }
  action
  flow_data { {
    template_id: UUID7.generate,
    deliver_at: Time.current
  }}
end
