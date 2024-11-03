require "test_helper"

class RuleTest < ActiveSupport::TestCase
  def account
    @account ||= Fabricate(:account)
  end

<<<<<<< Updated upstream
  def rule
    @rule ||= Fabricate.build(:rule, account: account)
=======
  test "has many goal_rules" do
    association = Rule.reflect_on_association(:goal_rules)
    assert_equal :has_many, association.macro
  end

  test "has many goals through goal_rules" do
    association = Rule.reflect_on_association(:goals)
    assert_equal :has_many, association.macro
    assert_equal :goal_rules, association.options[:through]
  end

  test "should not save rule without name" do
    rule = Rule.new(account: @account)
    assert_not rule.save, "Saved the rule without a name"
>>>>>>> Stashed changes
  end

  # Helper methods for property rules
  def numeric_property
    @numeric_property ||= Fabricate(:property, value_type: "numeric")
  end

<<<<<<< Updated upstream
  def text_property
    @text_property ||= Fabricate(:property, value_type: "text")
=======
  test "should not save rule without rule_data" do
    rule = Rule.new(account: @account)
    assert_not rule.save, "Saved the rule without a rule_data"
  end


  test "should have validation error on name when name is missing" do
    rule = Rule.new(account: @account)
    assert rule.invalid?, "Rule without a name should be invalid"
    assert rule.errors[:name].any?, "There should be an error for the name"
>>>>>>> Stashed changes
  end

  def boolean_property
    @boolean_property ||= Fabricate(:property, value_type: "boolean")
  end

  def datetime_property
    @datetime_property ||= Fabricate(:property, value_type: "datetime")
  end

<<<<<<< Updated upstream
  # Helper methods for trait rules
  def numeric_trait
    @numeric_trait ||= Fabricate(:trait, account: account, value_type: "numeric")
  end

  def text_trait
    @text_trait ||= Fabricate(:trait, account: account, value_type: "text")
  end

  def boolean_trait
    @boolean_trait ||= Fabricate(:trait, account: account, value_type: "boolean")
  end

  def datetime_trait
    @datetime_trait ||= Fabricate(:trait, account: account, value_type: "datetime")
  end

  ### Event Based Rule Tests

  ### Errors

  test "should be invalid without property_value for numeric property rule" do
    rule.ruleable = numeric_property
    rule.property_operator = "Greater than"
    rule.property_value = nil # Missing property_value
    rule.data = {
      property_operator: rule.property_operator,
      property_value: rule.property_value
    }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid without 'property_value'"
    assert_includes rule.errors[:property_value], "Numeric value must be present"
  end

  test "should be invalid without property_value for text property rule" do
    rule.ruleable = text_property
    rule.property_operator = "Equals"
    rule.property_value = nil # Missing property_value
    rule.data = {
      property_operator: rule.property_operator,
      property_value: rule.property_value
    }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid without 'property_value'"
    assert_includes rule.errors[:property_value], "Text value must be present"
  end

  test "should be invalid without datetime_from or datetime_to for within range operator" do
    rule.ruleable = datetime_property
    rule.occurrence_operator = "Has occurred"

    # Scenario 1: Missing 'datetime_from'
    rule.datetime_from = nil
    rule.datetime_to = "2024-12-31T23:59:59+00:00"
    rule.occurrence_inclusive = true
    rule.data = {
      occurrence_operator: rule.occurrence_operator,
      datetime_to: rule.datetime_to,
      occurrence_inclusive: rule.occurrence_inclusive
    }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid without 'datetime_from' for within range"
    assert_includes rule.errors[:datetime_from], "'datetime_from' must be present for implied 'within range'"

    # Scenario 2: Missing 'datetime_to'
    rule.datetime_from = "2024-01-01T00:00:00+00:00"
    rule.datetime_to = nil
    rule.data = {
      occurrence_operator: rule.occurrence_operator,
      datetime_from: rule.datetime_from,
      occurrence_inclusive: rule.occurrence_inclusive
    }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid without 'datetime_to' for within range"
    assert_includes rule.errors[:datetime_to], "'datetime_to' must be present for implied 'within range'"
  end

  test "should be invalid without occurrence_inclusive for within range operator" do
    rule.ruleable = datetime_property
    rule.occurrence_operator = "Has occurred"
    rule.datetime_from = "2024-01-01T00:00:00+00:00"
    rule.datetime_to = "2024-12-31T23:59:59+00:00"
    rule.occurrence_inclusive = nil  # Invalid value
    rule.data = {
      occurrence_operator: rule.occurrence_operator,
      datetime_from: rule.datetime_from,
      datetime_to: rule.datetime_to
    }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid without 'occurrence_inclusive' for within range"
    assert_includes rule.errors[:occurrence_inclusive], "'occurrence_inclusive' must be true or false"
  end
  # ## Good below this line
  test "should be invalid without 'from' or 'to' for within range operator" do
    rule.ruleable = numeric_property
    rule.property_operator = "within_range"

    # Scenario 1: Missing 'from' value
    rule.property_from = nil
    rule.property_to = 100
    rule.data = { property_operator: rule.property_operator, property_to: rule.property_to }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid without 'from' for within range"
    assert_includes rule.errors[:property_from], "'from' must be numeric for within range"

    # Scenario 2: Missing 'to' value
    rule.property_from = 50
    rule.property_to = nil
    rule.data = { property_operator: rule.property_operator, property_from: rule.property_from }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid without 'to' for within range"
    assert_includes rule.errors[:property_to], "'to' must be numeric for within range"
  end

  test "should be invalid with unsupported occurrence_operator" do
    rule.ruleable = datetime_property
    rule.occurrence_operator = "Since" # This should be invalid
    rule.data = { occurrence_operator: rule.occurrence_operator }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid with unsupported occurrence operator"
    assert_includes rule.errors[:occurrence_operator], "Invalid occurrence 'Since'"
  end

  test "should validate event rule with 'Has occurred' operator" do
    rule.ruleable = datetime_property
    rule.occurrence_operator = "Has occurred"
    rule.data = { occurrence_operator: rule.occurrence_operator }.stringify_keys

    assert rule.valid?, "Rule with 'Has occurred' operator should be valid"
    assert rule.save, "Failed to save a valid 'Has occurred' event rule"
  end

  test "should validate event rule with 'Has not occurred' operator" do
    rule.ruleable = datetime_property
    rule.occurrence_operator = "Has not occurred"
    rule.data = { occurrence_operator: rule.occurrence_operator }.stringify_keys

    assert rule.valid?, "Rule with 'Has not occurred' operator should be valid"
    assert rule.save, "Failed to save a valid 'Has not occurred' event rule"
  end

  # Numeric property tests
  test "should validate numeric event rule with greater than property_operator" do
    rule.ruleable = numeric_property
    rule.property_operator = "Greater than"
    rule.property_value = 100
    rule.data = { property_operator: rule.property_operator,
                  property_value: rule.property_value }.stringify_keys

    assert rule.valid?, "Event rule with numeric 'greater than' should be valid"
    assert rule.save, "Failed to save a valid numeric event rule"
  end

  test "should validate numeric event rule within range" do
    rule.ruleable = numeric_property
    rule.property_operator = "Within range"
    rule.property_from = 20
    rule.property_to = 100
    rule.property_inclusive = false
    rule.data = { property_operator: rule.property_operator,
                  property_from: rule.property_from, property_to: rule.property_to,
                  property_inclusive: rule.property_inclusive }.stringify_keys

    assert rule.valid?, "Event rule with numeric 'within range' should be valid"
    assert rule.save, "Failed to save a valid numeric event rule"
  end

  test "should be invalid without property_operator or occurrence_operator in data" do
    rule.ruleable = datetime_property
    rule.data = {}

    assert_not rule.valid?, "Rule should be invalid without an operator in data"
    assert_includes rule.errors[:data], "Missing operator in data"
  end

  test "should be invalid with invalid property operator for event-based rule" do
    rule.ruleable = datetime_property
    rule.property_operator = "InvalidOperator"
    rule.property_value = "2024-01-01T00:00:00+00:00"
    rule.data = {
      property_operator: rule.property_operator,
      property_value: rule.property_value
    }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid with an invalid property operator"
    assert_includes rule.errors[:property_operator],
      "Invalid datetime operator 'InvalidOperator'"
  end

  # Text property tests
  test "should validate text event rule with contains property_operator" do
    rule.ruleable = text_property
    rule.property_operator = "Contains"
    rule.property_value = "Some Text"
    rule.data = { property_operator: rule.property_operator,
                  property_value: rule.property_value,
                  case_sensitive: true }.stringify_keys

    assert rule.valid?, "Event rule with text 'contains' should be valid"
    assert rule.save, "Failed to save a valid text event rule"
  end

  test "should validate text event rule with equals property_operator" do
    rule.ruleable = text_property
    rule.property_operator = "Equals"
    rule.property_value = "Event Text"
    rule.data = { property_operator: rule.property_operator,
                  property_value: rule.property_value,
                  case_sensitive: false }.stringify_keys

    assert rule.valid?, "Event rule with text 'equals' should be valid"
    assert rule.save, "Failed to save a valid text event rule with equals operator"
  end

  # Boolean property tests
  test "should validate boolean event rule with is not property_operator" do
    rule.ruleable = boolean_property
    rule.property_operator = "Is not"
    rule.property_value = false
    rule.data = { property_operator: rule.property_operator,
                  property_value: rule.property_value }.stringify_keys

    assert rule.valid?, "Event rule with boolean 'is not' should be valid"
    assert rule.save, "Failed to save a valid boolean event rule"
  end

  test "should validate boolean event rule with is property_operator" do
    rule.ruleable = boolean_property
    rule.property_operator = "Is"
    rule.property_value = true
    rule.data = { property_operator: rule.property_operator,
                  property_value: rule.property_value }.stringify_keys

    assert rule.valid?, "Event rule with boolean 'is' should be valid"
    assert rule.save, "Failed to save a valid boolean event rule"
  end

  # Datetime property tests
  test "should validate datetime event rule with after property_operator" do
    rule.ruleable = datetime_property
    rule.property_operator = "After"
    rule.property_value = "2024-01-01T00:00:00+00:00"
    rule.data = { property_operator: rule.property_operator,
                  property_value: rule.property_value }.stringify_keys

    assert rule.valid?, "Event rule with datetime 'after' should be valid"
    assert rule.save, "Failed to save a valid datetime event rule"
  end

  test "should validate datetime event rule within range" do
    rule.ruleable = datetime_property
    rule.property_operator = "Within range"
    rule.property_from = "2023-01-01T00:00:00+00:00"
    rule.property_to = "2023-12-31T23:59:59+00:00"
    rule.property_inclusive = true
    rule.data = { property_operator: rule.property_operator,
                  property_from: rule.property_from, property_to: rule.property_to,
                  property_inclusive: rule.property_inclusive }.stringify_keys

    assert rule.valid?, "Event rule with datetime 'within range' should be valid"
    assert rule.save, "Failed to save a valid datetime event rule"
  end

  # Event occurrence tests
  test "should validate event occurrence with has occurred operator" do
    rule.ruleable = datetime_property
    rule.occurrence_operator = "Has occurred"
    rule.data = { occurrence_operator: rule.occurrence_operator,
                  datetime_from: rule.datetime_from }.stringify_keys

    assert rule.valid?, "Event rule with 'has occurred' should be valid"
    assert rule.save, "Failed to save a valid event rule"
  end

  test "should validate event non-occurrence with has not occurred operator" do
    rule.ruleable = datetime_property
    rule.occurrence_operator = "Has not occurred"
    rule.data = { occurrence_operator: rule.occurrence_operator,
                  datetime_from: rule.datetime_from }.stringify_keys

    assert rule.valid?, "Event rule with 'has not occurred' should be valid"
    assert rule.save, "Failed to save a valid event rule"
  end

  test "should validate datetime event rule within range of datetimes" do
    rule.ruleable = datetime_property
    rule.property_operator = "Within range"
    rule.property_from = "2024-01-01T00:00:00+00:00"
    rule.property_to = "2024-12-31T23:59:59+00:00"
    rule.property_inclusive = true
    rule.data = { property_operator: rule.property_operator,
                  property_from: rule.property_from,
                  property_to: rule.property_to,
                  property_inclusive: rule.property_inclusive }.stringify_keys

    assert rule.valid?, "Event rule with 'within range' should be valid"
    assert rule.save, "Failed to save a valid event rule with datetime 'within range'"
  end

  ### Person based rule tests

  ### Extra Error tests

  test "should validate operator" do
    rule.ruleable = numeric_trait
    rule.trait_operator = "Garbage"
    rule.trait_value = "30"
    rule.data = { trait_operator: rule.trait_operator,
                  trait_value: rule.trait_value }.stringify_keys

    assert_not rule.valid?, "Person rule should have a valid operator"
    assert_not rule.save, "Should not save to save an invalid person rule"
  end

  test "should validate missing trait operator" do
    rule.ruleable = numeric_trait
    rule.trait_operator = nil
    rule.trait_value = "30"
    rule.data = { trait_operator: rule.trait_operator,
                  trait_value: rule.trait_value }.stringify_keys

    assert_not rule.valid?, "Person rule should have a valid operator"
    assert_not rule.save, "Should not save to save an invalid person rule"
  end


  # Numeric trait tests
  test "should validate numeric person rule with greater than operator" do
    rule.ruleable = numeric_trait
    rule.trait_operator = "greater_than"
    rule.trait_value = "30"
    rule.data = { trait_operator: rule.trait_operator,
                  trait_value: rule.trait_value }.stringify_keys

    assert rule.valid?, "Person rule with numeric 'greater than' should be valid"
    assert rule.save, "Failed to save a valid numeric person rule"
  end

  test "should validate numeric person rule within range" do
    rule.ruleable = numeric_trait
    rule.trait_operator = "within_range"
    rule.trait_from = "20"
    rule.trait_to = "30"
    rule.trait_inclusive = true
    rule.data = { trait_operator: rule.trait_operator,
                  trait_from: rule.trait_from,
                  trait_to: rule.trait_to,
                  trait_inclusive: rule.trait_inclusive }.stringify_keys

    assert rule.valid?, "Person rule with numeric 'within range' should be valid"
    assert rule.save, "Failed to save a valid numeric person rule with range"
  end

  # Text trait tests
  test "should validate text person rule with equals operator" do
    rule.ruleable = text_trait
    rule.trait_operator = "equals"
    rule.trait_value = "Some Text"
    rule.data = { trait_operator: rule.trait_operator,
                  trait_value: rule.trait_value,
                  case_sensitive: false }.stringify_keys

    assert rule.valid?, "Person rule with text 'equals' operator should be valid"
    assert rule.save, "Failed to save a valid text person rule with equals"
  end

  test "should validate text person rule with contains operator" do
    rule.ruleable = text_trait
    rule.trait_operator = "contains"
    rule.trait_value = "Text"
    rule.data = { trait_operator: rule.trait_operator,
                  trait_value: rule.trait_value,
                  case_sensitive: true }.stringify_keys

    assert rule.valid?, "Person rule with text 'contains' operator should be valid"
    assert rule.save, "Failed to save a valid text person rule with contains"
  end

  # Boolean trait tests
  test "should validate boolean person rule with is operator" do
    rule.ruleable = boolean_trait
    rule.trait_operator = "is"
    rule.trait_value = true
    rule.data = { trait_operator: rule.trait_operator,
                  trait_value: rule.trait_value }.stringify_keys

    assert rule.valid?, "Person rule with boolean 'is' operator should be valid"
    assert rule.save, "Failed to save a valid boolean person rule with is"
  end

  # Datetime trait tests
  test "should validate datetime person rule with before operator" do
    rule.ruleable = datetime_trait
    rule.trait_operator = "before"
    rule.trait_value = "2023-10-25T23:48:46+00:00"
    rule.data = { trait_operator: rule.trait_operator,
                  trait_value: rule.trait_value }.stringify_keys

    assert rule.valid?, "Person rule with datetime 'before' operator should be valid"
    assert rule.save, "Failed to save a valid datetime person rule with before"
  end

  test "should validate datetime person rule within range" do
    rule.ruleable = datetime_trait
    rule.trait_operator = "within_range"
    rule.trait_from = "2023-01-01T00:00:00+00:00"
    rule.trait_to = "2023-12-31T23:59:59+00:00"
    rule.trait_inclusive = true
    rule.data = { trait_operator: rule.trait_operator,
                  trait_from: rule.trait_from,
                  trait_to: rule.trait_to,
                  trait_inclusive: rule.trait_inclusive }.stringify_keys

    assert rule.valid?, "Person rule with datetime 'within range' should be valid"
    assert rule.save, "Failed to save a valid datetime person rule with range"
  end

  # Invalid operator cases for person rules
  test "should be invalid without a numeric trait value for greater than" do
    rule.ruleable = numeric_trait
    rule.trait_operator = "Greater than"
    rule.data = { trait_operator: rule.trait_operator }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid without numeric value"
    assert_includes rule.errors[:trait_value],
      "Numeric value must be present for Greater than"
  end

  test "should be invalid with invalid range for numeric" do
    rule.ruleable = numeric_trait
    rule.trait_operator = "within_range"
    rule.trait_inclusive = true
    rule.data = { trait_operator: rule.trait_operator,
                  trait_inclusive: rule.trait_inclusive }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid without range"
    assert_includes rule.errors[:trait_from],
      "'from' and 'to' must be numeric for 'within range' operator"
  end

  test "should be invalid with invalid case_sensitive value for text" do
    rule.ruleable = text_trait
    rule.trait_operator = "Equals"
    rule.trait_value = "Some Text"
    rule.data = { trait_operator: rule.trait_operator,
                  trait_value: rule.trait_value,
                  case_sensitive: "invalid" }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid with invalid case_sensitive"
    assert_includes rule.errors[:case_sensitive],
      "case_sensitive must be true or false"
  end

  test "should be invalid with invalid datetime format for before operator" do
    rule.ruleable = datetime_trait
    rule.trait_operator = "before"
    rule.trait_value = "invalid-datetime"
    rule.data = { trait_operator: rule.trait_operator,
                  trait_value: rule.trait_value }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid with invalid datetime format"
    assert_includes rule.errors[:trait_value],
      "Value must be a valid ISO8601 datetime string"
=======
  test "should save rule with duplicate name in different accounts" do
    different_account = accounts(:two)
    rule_with_duplicate_name = Rule.new(account: different_account, name: @rule.name, rule_data: "test")
    assert rule_with_duplicate_name.save, "Did not save the rule with a duplicate name in a different account"
>>>>>>> Stashed changes
  end
end
