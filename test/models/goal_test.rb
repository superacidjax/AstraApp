require "test_helper"

class GoalTest < ActiveSupport::TestCase
  setup do
    @goal = goals(:one)
  end

  test "should not save goal without success_rate" do
    goal = Goal.new
    assert_not goal.save, "Saved the goal without a success_rate"
  end

  test "fixture goal should be valid" do
    assert @goal.valid?, "Fixture goal is not valid"
  end

  test "should have validation error on success_rate when success_rate is missing" do
    goal = Goal.new(success_rate: nil)
    assert goal.invalid?, "Goal without a success_rate should be invalid"
    assert goal.errors[:success_rate].any?, "There should be an error for the success_rate"
  end

  test "should not save goal with non-numeric success_rate" do
    goal = Goal.new(success_rate: "not_a_number")
    assert_not goal.save, "Saved the goal with a non-numeric success_rate"
  end

  test "should have validation error on success_rate when success_rate is non-numeric" do
    goal = Goal.new(success_rate: "not_a_number")
    assert goal.invalid?, "Goal with non-numeric success_rate should be invalid"
    assert goal.errors[:success_rate].any?, "There should be an error for the non-numeric success_rate"
  end
end
