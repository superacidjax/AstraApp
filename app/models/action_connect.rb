class ActionConnect < Action
  jsonb_accessor :data,
    integration_id: :uuid,
    integration_name: :string
end
