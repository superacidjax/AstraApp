require "test_helper"

class FlowGoalTest < ActiveSupport::TestCase
  # Use the fixture data for flow goals
  setup do
    @flow_goal = flow_goals(:one)
  end

  test "should not save flow goal without success_rate" do
    flow_goal = FlowGoal.new(flow: @flow_goal.flow, goal: @flow_goal.goal,
                            success_rate: nil)
    assert_not flow_goal.save, "Saved the flow goal without a success_rate"
  end

  test "fixture flow goal should be valid" do
    assert @flow_goal.valid?, "Fixture flow goal is not valid"
  end

  test "should have validation error on success_rate when success_rate is missing" do
    flow_goal = FlowGoal.new(flow: @flow_goal.flow, goal: @flow_goal.goal,
                            success_rate: nil)
    assert flow_goal.invalid?, "Flow goal without a success_rate should be invalid"
    assert flow_goal.errors[:success_rate].any?, "There should be an error for the success_rate"
  end

  test "should not save flow goal with non-numeric success_rate" do
    flow_goal = FlowGoal.new(flow: @flow_goal.flow, goal: @flow_goal.goal, success_rate: "not_a_number")
    assert_not flow_goal.save, "Saved the flow goal with a non-numeric success_rate"
  end

  test "should have validation error on success_rate when success_rate is non-numeric" do
    flow_goal = FlowGoal.new(flow: @flow_goal.flow, goal: @flow_goal.goal, success_rate: "not_a_number")
    assert flow_goal.invalid?, "Flow goal with non-numeric success_rate should be invalid"
    assert flow_goal.errors[:success_rate].any?, "There should be an error for the non-numeric success_rate"
  end
end
