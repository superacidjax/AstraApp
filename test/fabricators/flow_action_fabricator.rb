Fabricator(:flow_action) do
  flow
  action { Fabricate(:action_sms) }
  data { {} }
end
