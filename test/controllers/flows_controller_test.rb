require "test_helper"

class FlowsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = Fabricate(:account)
    prepare_test_goal(@account, "PersonRule")
    @sms_action = Fabricate(:action, type: "ActionSms", account: @account, name: "My SMS")

    @flow = Fabricate(:flow, account: @account, name: "Existing Flow")
    @goal = Fabricate(:goal_with_rules, account: @account)
    @flow.flow_goals.create!(goal: @goal)
    @flow.flow_actions.create!(type: "FlowActionSms", action: @sms_action,
                               data: { "content" => "Hello World!" })
  end

  test "should get index" do
    get flows_url
    assert_response :success
    assert_select "h1", "Flows"
    assert_select "td", "Existing Flow"
  end

  test "should show flow" do
    get flow_url(@flow)
    assert_response :success
    assert_select "h1", text: @flow.name
  end

  test "should get new" do
    get new_flow_url
    assert_response :success
    assert_select "form[action='#{flows_path}']"
    assert_select "input[name='flow[name]']"
    assert_select "select[name^='flow[flow_goals_attributes]'][name$='[goal_id]']"
    assert_select "select[name^='flow[flow_actions_attributes]'][name$='[action_id]']"
  end

  test "should create flow with valid data" do
    assert_difference("Flow.count", 1) do
      assert_difference("FlowGoal.count", 1) do
        assert_difference("FlowAction.count", 1) do
          post flows_url, params: {
            flow: {
              name: "New Flow",
              flow_goals_attributes: [
                { goal_id: @goal.id, success_rate: "99.9" }
              ],
              flow_actions_attributes: [
                { type: "FlowActionSms", action_id: @sms_action.id,
                  data: { content: "Hello!" } }
              ]
            }
          }
        end
      end
    end

    assert_redirected_to flow_path(Flow.last)
    follow_redirect!
    assert_select "h1", "New Flow"
    assert_select ".notification.is-success", text: "Flow was successfully created."
  end

  test "should not create flow with invalid data" do
    # Missing name
    assert_no_difference("Flow.count") do
      post flows_url, params: {
        flow: {
          name: "",
          flow_goals_attributes: [
            { goal_id: @goal.id }
          ],
          flow_actions_attributes: [
            { type: "FlowActionSms", action_id: @sms_action.id,
              data: { content: "Hello!" } }
          ]
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select "form[action='#{flows_path}']"
    assert_select ".notification.is-danger", "There were errors creating the flow."
  end

  test "should get edit" do
    get edit_flow_url(@flow)
    assert_response :success
    assert_select "form[action='#{flow_path(@flow)}']"
    assert_select "input[name='flow[name]'][value='Existing Flow']"
  end

  test "should update flow with valid data" do
    patch flow_url(@flow), params: {
      flow: {
        name: "Updated Flow",
        flow_goals_attributes: [
          { id: @flow.flow_goals.first.id, goal_id: @goal.id }
        ],
        flow_actions_attributes: [
          { id: @flow.flow_actions.first.id, type: "FlowActionSms",
            action_id: @sms_action.id, data: { content: "Updated content" } }
        ]
      }
    }

    assert_redirected_to flow_path(@flow)
    follow_redirect!
    assert_select "h1", "Updated Flow"
    assert_select ".notification.is-success", text: "Flow was successfully updated."
  end

  test "should not update flow with invalid data" do
    patch flow_url(@flow), params: {
      flow: {
        name: "",
        flow_goals_attributes: [
          { id: @flow.flow_goals.first.id, goal_id: @goal.id }
        ],
        flow_actions_attributes: [
          { id: @flow.flow_actions.first.id, type: "FlowActionSms",
            action_id: @sms_action.id, data: { content: "Updated content" } }
        ]
      }
    }

    assert_response :unprocessable_entity
    assert_select "form[action='#{flow_path(@flow)}']"
    assert_select ".notification.is-danger", "There were errors updating the flow."
  end

  test "should destroy flow" do
    assert_difference("Flow.count", -1) do
      delete flow_url(@flow)
    end

    assert_redirected_to flows_path
    follow_redirect!
    assert_select ".notification.is-success", text: "Flow was successfully destroyed."
  end
end
