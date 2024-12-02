require "test_helper"

class GoalRuleTest < ActiveSupport::TestCase
  setup do
    @account = Fabricate(:account)
    @goal = Fabricate.build(:goal, account: @account)
    @trait_rule = Fabricate(:person_rule, account: @account)
    @goal_rule = Fabricate.build(:goal_rule, goal: @goal, rule: @trait_rule)
  end

  test "should not save goal rule without state" do
    goal_rule = Fabricate.build(:goal_rule, goal: @goal, rule: @trait_rule, state: nil)
    assert_not goal_rule.save, "Saved the goal rule without a state"
  end

  test "fabricated goal rule should be valid" do
    assert @goal_rule.valid?, "Fabricated goal rule is not valid"
  end

  test "should have default state as initial" do
    goal_rule = Fabricate.build(:goal_rule, goal: @goal, rule: @trait_rule)
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
