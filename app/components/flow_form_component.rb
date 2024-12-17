class FlowFormComponent < ViewComponent::Base
  def initialize(flow:, url:, method:, goals:, sms_actions:)
    @flow = flow
    @url = url
    @method = method
    @goals = goals
    @sms_actions = sms_actions
  end
end
