class FlowActionWait < FlowAction
  jsonb_accessor :data,
    wait_in_seconds: :integer
end
