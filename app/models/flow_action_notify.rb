class FlowActionNotify < FlowAction
  jsonb_accessor :data,
    destination: :string
end
