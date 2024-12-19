require "test_helper"

class FlowFormComponentTest < ViewComponent::TestCase
  include Rails.application.routes.url_helpers

  setup do
    @account = Fabricate(:account)
    prepare_test_goal(@account, "PersonRule")
    @sms_action = Fabricate(
      :action, type: "ActionSms",  account: @account, name: "Test SMS"
    )

    @flow = @account.flows.new
    @flow.flow_goals.build(goal: @goal, success_rate: 100.0)
    @flow.flow_actions.build(
      type: "FlowActionSms",
      action: @sms_action,
      data: { "content" => "Hello!" }
    )

    @goals = [ [ "Test Goal", @goal.id ] ]
    @sms_actions = [ [ "Test SMS", @sms_action.id ] ]
  end

  test "renders a form with name, goal, and SMS action fields" do
    render_inline(FlowFormComponent.new(
      flow: @flow,
      url: flows_path,
      method: :post,
      goals: @goals,
      sms_actions: @sms_actions
    ))

    # Check form action and method
    assert_selector "form[action='#{flows_path}'][method='post']"

    # Name field
    assert_selector "label.label[for='flow_name']", text: "Name"
    assert_selector "input.input[name='flow[name]']"

    # Goal dropdown
    assert_selector "label.label[for='flow_flow_goals_attributes_0_goal_id']", text: "Goal"
    assert_selector "select[name='flow[flow_goals_attributes][0][goal_id]'] option", text: "Test Goal"

    # SMS Action dropdown
    assert_selector "label.label[for='flow_flow_actions_attributes_0_action_id']", text: "Action"
    assert_selector "select[name='flow[flow_actions_attributes][0][action_id]'] option", text: "Test SMS"

    # SMS Content field
    assert_selector "label.label[for='flow_flow_actions_attributes_0_content']", text: "SMS Content"
    assert_selector "textarea[name='flow[flow_actions_attributes][0][content]']", text: "Hello!"
  end
end
