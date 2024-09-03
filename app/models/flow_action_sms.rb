class FlowActionSms < FlowAction
  jsonb_accessor :flow_data,
    template_id: :uuid
end
