Fabricator(:flow_action_email) do
  flow { Fabricate(:flow) }
  action
  data { {
    template_id: UUID7.generate,
    deliver_at: Time.current
  }}
end
