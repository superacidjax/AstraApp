class FlowActionConnect < FlowAction
  jsonb_accessor :flow_data,
    data_to_send: :string
end
