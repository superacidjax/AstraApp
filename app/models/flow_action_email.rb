class FlowActionEmail < FlowAction
  jsonb_accessor :data,
    template_id: :uuid,
    deliver_at: :datetime
end
