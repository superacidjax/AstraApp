require "test_helper"

class GoalTest < ActiveSupport::TestCase
  test "fixture goal should be valid" do
    goal = Fabricate.build(:goal_with_rules)
    assert goal.valid?, "Fixture goal is not valid"
  end

  test "should not save goal without success_rate" do
    goal = Fabricate.build(:goal_with_rules, success_rate: nil)
    assert_not goal.save, "Saved the goal without a success_rate"
  end

  test "should have validation error on name when name is missing" do
    goal = Fabricate.build(:goal_with_rules, name: "")
    assert goal.invalid?, "Goal without a name should be invalid"
    assert goal.errors["name"].any?, "There should be an error for the name"
  end

  test "should have validation error on success_rate when success_rate is missing" do
    goal = Fabricate.build(:goal_with_rules, success_rate: nil)
    assert goal.invalid?, "Goal without a success_rate should be invalid"
    assert goal.errors["success_rate"].any?, "There should be an error for the success_rate"
  end

  test "should not save goal with non-numeric success_rate" do
    goal = Fabricate.build(:goal_with_rules, success_rate: "not_a_number")
    assert_not goal.save, "Saved the goal with a non-numeric success_rate"
  end

  test "should require GoalRules to have states initial and end" do
    goal = Fabricate.build(:goal_with_rules)
    initial_rule = goal.goal_rules.first
    end_rule  = goal.goal_rules.last
    end_rule.state = "initial"
    assert_not goal.valid?, "Goal should be invalid if GoalRules do not include both 'initial' and 'end' states"
    assert_includes goal.errors[:goal_rules], "must include one 'initial' and one 'end' GoalRule"
  end
end
