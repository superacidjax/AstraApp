class FlowActionWait < FlowAction
  jsonb_accessor :flow_data,
    wait_in_seconds: :integer
end
