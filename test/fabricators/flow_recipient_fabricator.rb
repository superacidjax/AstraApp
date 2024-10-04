Fabricator(:flow_recipient) do
  flow
  person
  status { 5 }
  is_goal_achieved { false }
  last_completed_flow_action { nil }
end
