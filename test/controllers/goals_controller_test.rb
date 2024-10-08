require "test_helper"

class GoalsControllerTest < ActionDispatch::IntegrationTest
  include GoalDataHelper

  setup do
    @account = Fabricate(:account)
    @client_application = Fabricate(:client_application, account: @account)
    @trait_text = Fabricate(:trait, account: @account, value_type: "text")
    @trait_numeric = Fabricate(:trait, account: @account, value_type: "numeric")
    @trait_boolean = Fabricate(:trait, account: @account, value_type: "boolean")
    @property_numeric = Fabricate(
      :property, event: Fabricate(
        :event, client_application: @client_application), value_type: "numeric"
    )
    @property_datetime = Fabricate(
      :property, event: Fabricate(
        :event, client_application: @client_application), value_type: "datetime"
    )
    @goal = Fabricate(:goal, account: @account, data: valid_goal_data(
      trait_text: @trait_text,
      trait_numeric: @trait_numeric,
      trait_boolean: @trait_boolean,
      property_numeric: @property_numeric,
      property_datetime: @property_datetime
    ))
  end

  test "should successfully create goal and redirect" do
    post goals_url, params: {
      goal: {
        name: "Simplified Goal",
        description: "A goal with rules and rule groups",
        account_id: @account.id,
        data: valid_goal_data(
          trait_text: @trait_text,
          trait_numeric: @trait_numeric,
          trait_boolean: @trait_boolean,
          property_numeric: @property_numeric,
          property_datetime: @property_datetime
        )
      }
    }

    goal = Goal.find_by_name("Simplified Goal")
    assert_redirected_to goal_url(goal)
    follow_redirect!
    assert_select "h1", "Simplified Goal"
  end

  test "should render new with errors on failure" do
    post goals_url, params: { goal: { name: "", account_id: nil } }

    assert_response :unprocessable_entity
    assert_select "div#error_explanation"
  end

  test "should get index" do
    get goals_url
    assert_response :success
    assert_select "h1", "Goals"
    assert_match @goal.name, response.body
  end

  test "should show goal" do
    get goal_url(@goal)
    assert_response :success
    assert_select "h1", @goal.name
  end

  test "should redirect to index with flash danger if goal not found" do
    get goal_url("non-existent-id")
    assert_redirected_to goals_url
    follow_redirect!
    assert_select ".alert-danger", "Goal not found"
  end
end
