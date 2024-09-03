class FlowActionNotify < FlowAction
  jsonb_accessor :flow_data,
    destination: :string
end
