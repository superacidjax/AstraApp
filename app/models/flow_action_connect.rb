class FlowActionConnect < FlowAction
  jsonb_accessor :data,
    data_to_send: :string
end
