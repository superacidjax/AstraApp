class FlowActionEmail < FlowAction
  jsonb_accessor :flow_data,
    template_id: :uuid,
    deliver_at: :datetime
end
