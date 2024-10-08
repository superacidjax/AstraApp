require "test_helper"

class FlowGoalTest < ActiveSupport::TestCase
  setup do
    @flow = Fabricate(:flow)
    @goal = Fabricate(:goal, data: valid_goal_data)
    @flow_goal = Fabricate(:flow_goal, flow: @flow, goal: @goal)
  end

  test "should not save flow goal without success_rate" do
    flow_goal = Fabricate.build(:flow_goal, flow: @flow, goal: @goal, success_rate: nil)
    assert_not flow_goal.save, "Saved the flow goal without a success_rate"
  end

  test "fabricated flow goal should be valid" do
    assert @flow_goal.valid?, "Fabricated flow goal is not valid"
  end

  test "should have validation error on success_rate when success_rate is missing" do
    flow_goal = Fabricate.build(:flow_goal, flow: @flow, goal: @goal, success_rate: nil)
    assert flow_goal.invalid?, "Flow goal without a success_rate should be invalid"
    assert flow_goal.errors[:success_rate].any?, "There should be an error for the success_rate"
  end

  test "should not save flow goal with non-numeric success_rate" do
    flow_goal = Fabricate.build(:flow_goal, flow: @flow, goal: @goal, success_rate: "not_a_number")
    assert_not flow_goal.save, "Saved the flow goal with a non-numeric success_rate"
  end

  test "should have validation error on success_rate when success_rate is non-numeric" do
    flow_goal = Fabricate.build(:flow_goal, flow: @flow, goal: @goal, success_rate: "not_a_number")
    assert flow_goal.invalid?, "Flow goal with non-numeric success_rate should be invalid"
    assert flow_goal.errors[:success_rate].any?, "There should be an error for the non-numeric success_rate"
  end

  private

  def valid_goal_data
    {
      "initial_state" => {
        "items" => [
          {
            "type" => "rule_group",
            "operator" => "OR",
            "items" => [
              {
                "type" => "rule",
                "rule_id" => Fabricate(:trait_rule).id,
                "operator" => "AND"
              },
              {
                "type" => "rule",
                "rule_id" => Fabricate(:property_rule).id,
                "operator" => nil
              }
            ]
          },
          {
            "type" => "rule",
            "rule_id" => Fabricate(:property_rule).id,
            "operator" => nil
          }
        ]
      },
      "end_state" => {
        "items" => [
          {
            "type" => "rule",
            "rule_id" => Fabricate(:trait_rule).id,
            "operator" => nil
          }
        ]
      }
    }
  end
end
