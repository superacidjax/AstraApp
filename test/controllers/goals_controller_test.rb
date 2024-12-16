require "test_helper"

class GoalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = Fabricate(:account)
    @user = Fabricate(:user)
    Fabricate(:account_user, account: @account, user: @user)
    @trait = Fabricate(:trait, account: @account, value_type: :numeric)
    @client_app = Fabricate(:client_application, account: @account)
    @event = Fabricate(:event, client_application: @client_app)
    @property = Fabricate(:property, event: @event, value_type: :numeric)
    @goal = Fabricate(:goal_with_rules, account: @account)
  end

  test "should get index" do
    get goals_url
    assert_response :success
    assert_select "h1", text: "Goals"
  end

  test "should show goal" do
    get goal_url(@goal)
    assert_response :success
    assert_select "h1", text: @goal.name
  end

  test "should get new" do
    get new_goal_url
    assert_response :success

    assert_select "form[action=?][method=?]", goals_path, "post" do
      assert_select "input[name='goal[name]']"
      assert_select "textarea[name='goal[description]']"

      assert_select "h2", text: "Initial State"
      assert_select "select[id^=traits_]"
      assert_select "select[id^=operator_]"
      assert_select "option", text: "Select an operator"
    end
  end

  test "should create a goal with rules" do
    post goals_url, params: {
      goal: {
        name: "Test Goal",
        description: "A test goal",
        success_rate: "50.0",
        goal_rules_attributes: {
          "0" => {
            state: "initial",
            rule_attributes: {
              type: "EventRule",
              name: "Initial Rule",
              operator: "Greater than",
              value: "100",
              ruleable_type: "Property",
              ruleable_id: @property.id
            }
          },
          "1" => {
            state: "end",
            rule_attributes: {
              type: "PersonRule",
              name: "End Rule",
              operator: "less_than",
              value: "28",
              ruleable_type: "Trait",
              ruleable_id: @trait.id
            }
          }
        }
      }
    }

    assert_redirected_to goal_path(Goal.last)
    created_goal = Goal.last
    assert_equal "Test Goal", created_goal.name
    assert_equal 2, created_goal.goal_rules.size

    initial_rule = created_goal.goal_rules.find_by(state: :initial).rule
    assert_equal "EventRule", initial_rule.type
    assert_equal @property.id, initial_rule.ruleable_id

    end_rule = created_goal.goal_rules.find_by(state: :end).rule
    assert_equal "PersonRule", end_rule.type
    assert_equal @trait.id, end_rule.ruleable_id
  end

  # test "should fail to create goal if invalid" do
  #   post goals_url, params: {
  #     goal: {
  #       description: "No name",
  #       success_rate: "50.0"
  #     }
  #   }
  #
  #   assert_response :unprocessable_entity
  #   assert_select ".notification.is-danger", text: "There were errors creating the goal."
  #   assert_select "form" do
  #     assert_select "[action=?]", goals_path
  #     assert_select "[method=?]", "post"
  #   end
  # end
  #
  # test "should get edit" do
  #   get edit_goal_url(@goal)
  #   assert_response :success
  #
  #   assert_select "form[action=?][method=?]", goal_path(@goal), "post" do
  #     assert_select "input[name='goal[name]'][value=?]", @goal.name
  #     assert_select "textarea[name='goal[description]']", @goal.description
  #
  #     assert_select "h2", text: "End State"
  #     assert_select "select[id^=traits_]"
  #     assert_select "select[id^=operator_]"
  #   end
  # end
  #
  # test "should update goal" do
  #   patch goal_url(@goal), params: {
  #     goal: {
  #       name: "Updated Goal Name"
  #     }
  #   }
  #
  #   assert_redirected_to goal_url(@goal)
  #   @goal.reload
  #   assert_equal "Updated Goal Name", @goal.name
  # end
  #
  # test "should destroy goal" do
  #   assert_difference("Goal.count", -1) do
  #     delete goal_url(@goal)
  #   end
  #   assert_redirected_to goals_url
  # end
end
