class FlowActionSms < FlowAction
  jsonb_accessor :data,
    content: :string
end
