require "test_helper"

class GoalRuleTest < ActiveSupport::TestCase
  setup do
    @goal_rule = goal_rules(:one)
  end

  test "should not save goal rule without state" do
    goal_rule = GoalRule.new(goal: @goal_rule.goal, rule: @goal_rule.rule,
                            state: nil)
    assert_not goal_rule.save, "Saved the goal rule without a state"
  end

  test "fixture goal rule should be valid" do
    assert @goal_rule.valid?, "Fixture goal rule is not valid"
  end

  test "should have default state as initial" do
    goal_rule = GoalRule.new(goal: @goal_rule.goal, rule: @goal_rule.rule)
    assert_equal "initial", goal_rule.state, "Default state is not 'initial'"
  end

  test "should set and get state as initial" do
    @goal_rule.state = "initial"
    assert_equal "initial", @goal_rule.state, "State was not set to 'initial'"
  end

  test "should set and get state as end" do
    @goal_rule.state = "end"
    assert_equal "end", @goal_rule.state, "State was not set to 'end'"
  end
end
