require "test_helper"

class GoalTest < ActiveSupport::TestCase
  setup do
    @account = Fabricate(:account)
    # Use traits and properties as ruleable objects for rules
    @trait_rule1 = Fabricate(:trait_rule, account: @account)
    @trait_rule2 = Fabricate(:trait_rule, account: @account)
    @property_rule1 = Fabricate(:property_rule, account: @account)
    @property_rule2 = Fabricate(:property_rule, account: @account)
  end

  test "fixture goal should be valid" do
    goal = Fabricate.build(:goal, data: valid_goal_data)
    assert goal.valid?, "Fixture goal is not valid"
  end

  test "should not save goal without success_rate" do
    goal = Fabricate.build(:goal, data: valid_goal_data, success_rate: nil)
    assert_not goal.save, "Saved the goal without a success_rate"
  end

  test "should have validation error on name when name is missing" do
    goal = Fabricate.build(:goal, data: valid_goal_data, name: "")
    assert goal.invalid?, "Goal without a name should be invalid"
    assert goal.errors[:name].any?, "There should be an error for the name"
  end

  test "should have validation error on success_rate when success_rate is missing" do
    goal = Fabricate.build(:goal, data: valid_goal_data, success_rate: nil)
    assert goal.invalid?, "Goal without a success_rate should be invalid"
    assert goal.errors[:success_rate].any?, "There should be an error for the success_rate"
  end

  test "should not save goal with non-numeric success_rate" do
    goal = Fabricate.build(:goal, data: valid_goal_data, success_rate: "not_a_number")
    assert_not goal.save, "Saved the goal with a non-numeric success_rate"
  end

  test "valid goal with correct data structure" do
    goal = Fabricate.build(:goal, data: valid_goal_data, account: @account)
    assert goal.valid?, "Goal should be valid with correct data structure"
    assert goal.save, "Goal should be saved successfully"
  end

  test "invalid goal with missing operator in rule group" do
    invalid_data = {
      "initial_state" => {
        "items" => [
          {
            "type" => "rule_group",
            "items" => [
              {
                "type" => "rule",
                "rule_id" => @trait_rule1.id,
                "operator" => "AND"
              },
              {
                "type" => "rule",
                "rule_id" => @trait_rule2.id,
                "operator" => nil
              }
            ]
          },
          {
            "type" => "rule",
            "rule_id" => @property_rule1.id,
            "operator" => nil
          }
        ]
      },
      "end_state" => {
        "items" => [
          {
            "type" => "rule",
            "rule_id" => @property_rule2.id,
            "operator" => nil
          }
        ]
      }
    }.to_json

    goal = Fabricate.build(:goal, data: invalid_data)
    assert_not goal.valid?, "Goal should be invalid without operator in rule group"
    assert_includes goal.errors[:data], "initial_state: Operator is required between items."
  end

  test "invalid goal with invalid operator value" do
    invalid_data = {
      "initial_state" => {
        "items" => [
          {
            "type" => "rule",
            "rule_id" => @trait_rule1.id,
            "operator" => "INVALID_OP"
          },
          {
            "type" => "rule",
            "rule_id" => @trait_rule2.id,
            "operator" => nil
          }
        ]
      }
    }.to_json

    goal = Fabricate.build(:goal, data: invalid_data)
    assert_not goal.valid?, "Goal should be invalid with invalid operator"
    assert_includes goal.errors[:data], "initial_state: Operator 'INVALID_OP' is not valid. Allowed operators are AND, OR, NOT."
  end

  test "invalid goal with missing rule_id" do
    invalid_data = {
      "initial_state" => {
        "items" => [
          {
            "type" => "rule",
            "operator" => nil
          }
        ]
      }
    }.to_json

    goal = Fabricate.build(:goal, data: invalid_data)
    assert_not goal.valid?, "Goal should be invalid without rule_id"
    assert_includes goal.errors[:data], "initial_state: Rule ID is required."
  end

  test "invalid goal with rule group containing less than two items" do
    invalid_data = {
      "initial_state" => {
        "items" => [
          {
            "type" => "rule_group",
            "operator" => nil,
            "items" => [
              {
                "type" => "rule",
                "rule_id" => @trait_rule1.id,
                "operator" => nil
              }
            ]
          }
        ]
      }
    }.to_json

    goal = Fabricate.build(:goal, data: invalid_data)
    assert_not goal.valid?, "Goal should be invalid with rule group containing less than two items"
    assert_includes goal.errors[:data], "initial_state -> Rule Group: Rule group must contain at least two items."
  end

  test "invalid goal with operator on last item" do
    invalid_data = {
      "initial_state" => {
        "items" => [
          {
            "type" => "rule",
            "rule_id" => @trait_rule1.id,
            "operator" => "AND"
          },
          {
            "type" => "rule",
            "rule_id" => @trait_rule2.id,
            "operator" => "OR" # Operator should not be present here
          }
        ]
      }
    }.to_json

    goal = Fabricate.build(:goal, data: invalid_data)
    assert_not goal.valid?, "Goal should be invalid with operator on last item"
    assert_includes goal.errors[:data], "initial_state: Operator should not be present on the last item."
  end

  test "invalid goal with invalid item type" do
    invalid_data = {
      "initial_state" => {
        "items" => [
          {
            "type" => "invalid_type",
            "operator" => nil
          }
        ]
      }
    }.to_json

    goal = Fabricate.build(:goal, data: invalid_data)
    assert_not goal.valid?, "Goal should be invalid with invalid item type"
    assert_includes goal.errors[:data], "initial_state: Invalid item type 'invalid_type'."
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
                "rule_id" => @trait_rule1.id,
                "operator" => "AND"
              },
              {
                "type" => "rule",
                "rule_id" => @trait_rule2.id,
                "operator" => nil
              }
            ]
          },
          {
            "type" => "rule",
            "rule_id" => @property_rule1.id,
            "operator" => nil
          }
        ]
      },
      "end_state" => {
        "items" => [
          {
            "type" => "rule",
            "rule_id" => @property_rule2.id,
            "operator" => nil
          }
        ]
      }
    }.to_json
  end
end
