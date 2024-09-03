class ActionNotify < Action
  jsonb_accessor :data,
    destination: :string
end
