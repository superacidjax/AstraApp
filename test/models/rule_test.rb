require "test_helper"

class RuleTest < ActiveSupport::TestCase
  def account
    @account ||= Fabricate(:account)
  end

  def rule
    @rule ||= Fabricate.build(:rule, account: account)
  end

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

  # Helper methods for property rules
  def numeric_property
    @numeric_property ||= Fabricate(:property, value_type: "numeric")
  end

  def text_property
    @text_property ||= Fabricate(:property, value_type: "text")
  end

  def boolean_property
    @boolean_property ||= Fabricate(:property, value_type: "boolean")
  end

  def datetime_property
    @datetime_property ||= Fabricate(:property, value_type: "datetime")
  end

  # Person-based rule tests (Trait)
  # Numeric
  test "should validate numeric person rule with greater than operator" do
    rule.ruleable = numeric_trait
    rule.operator = "Greater than"
    rule.value = 30
    rule.data = { operator: rule.operator, value: rule.value }.stringify_keys

    assert rule.valid?, "Person rule with numeric 'greater than' operator should be valid"
    assert rule.save, "Failed to save a valid numeric person rule"
  end

  test "should validate numeric person rule within range" do
    rule.ruleable = numeric_trait
    rule.operator = "Within range"
    rule.from = 20
    rule.to = 30
    rule.inclusive = true
    rule.data = { operator: rule.operator, from: rule.from, to: rule.to, inclusive: rule.inclusive }.stringify_keys

    assert rule.valid?, "Person rule with numeric 'within range' operator should be valid"
    assert rule.save, "Failed to save a valid numeric person rule with within range operator"
  end

  # Text
  test "should validate text person rule with equals operator" do
    rule.ruleable = text_trait
    rule.operator = "Equals"
    rule.value = "Some Text"
    rule.data = { operator: rule.operator, value: rule.value, case_sensitive: false }.stringify_keys

    assert rule.valid?, "Person rule with text 'equals' operator should be valid"
    assert rule.save, "Failed to save a valid text person rule with equals operator"
  end

  test "should validate text person rule with contains operator" do
    rule.ruleable = text_trait
    rule.operator = "Contains"
    rule.value = "Text"
    rule.data = { operator: rule.operator, value: rule.value, case_sensitive: true }.stringify_keys

    assert rule.valid?, "Person rule with text 'contains' operator should be valid"
    assert rule.save, "Failed to save a valid text person rule with contains operator"
  end

  # Boolean
  test "should validate boolean person rule with is operator" do
    rule.ruleable = boolean_trait
    rule.operator = "Is"
    rule.value = true
    rule.data = { operator: rule.operator, value: rule.value }.stringify_keys

    assert rule.valid?, "Person rule with boolean 'is' operator should be valid"
    assert rule.save, "Failed to save a valid boolean person rule with is operator"
  end

  # Datetime
  test "should validate datetime person rule with before operator" do
    rule.ruleable = datetime_trait
    rule.operator = "Before"
    rule.value = "2023-10-25T23:48:46+00:00"
    rule.data = { operator: rule.operator, value: rule.value }.stringify_keys

    assert rule.valid?, "Person rule with datetime 'before' operator should be valid"
    assert rule.save, "Failed to save a valid datetime person rule with before operator"
  end

  test "should validate datetime person rule within range" do
    rule.ruleable = datetime_trait
    rule.operator = "Within range"
    rule.from = "2023-01-01T00:00:00+00:00"
    rule.to = "2023-12-31T23:59:59+00:00"
    rule.inclusive = true
    rule.data = { operator: rule.operator, from: rule.from, to: rule.to, inclusive: rule.inclusive }.stringify_keys

    assert rule.valid?, "Person rule with datetime 'within range' operator should be valid"
    assert rule.save, "Failed to save a valid datetime person rule with within range operator"
  end

  # Event-based rule tests (Property)
  # Numeric
  test "should validate numeric event rule with greater than operator" do
    rule.ruleable = numeric_property
    rule.operator = "Greater than"
    rule.value = 100
    rule.data = { operator: rule.operator, value: rule.value }.stringify_keys

    assert rule.valid?, "Event rule with numeric 'greater than' operator should be valid"
    assert rule.save, "Failed to save a valid numeric event rule"
  end

  test "should validate numeric event rule within range" do
    rule.ruleable = numeric_property
    rule.operator = "Within range"
    rule.from = 20
    rule.to = 100
    rule.inclusive = false
    rule.data = { operator: rule.operator, from: rule.from, to: rule.to, inclusive: rule.inclusive }.stringify_keys

    assert rule.valid?, "Event rule with numeric 'within range' operator should be valid"
    assert rule.save, "Failed to save a valid numeric event rule with within range operator"
  end

  # Text
  test "should validate text event rule with contains operator" do
    rule.ruleable = text_property
    rule.operator = "Contains"
    rule.value = "Some Text"
    rule.data = { operator: rule.operator, value: rule.value, case_sensitive: true }.stringify_keys

    assert rule.valid?, "Event rule with text 'contains' operator should be valid"
    assert rule.save, "Failed to save a valid text event rule with contains operator"
  end

  test "should validate text event rule with equals operator" do
    rule.ruleable = text_property
    rule.operator = "Equals"
    rule.value = "Event Text"
    rule.data = { operator: rule.operator, value: rule.value, case_sensitive: false }.stringify_keys

    assert rule.valid?, "Event rule with text 'equals' operator should be valid"
    assert rule.save, "Failed to save a valid text event rule with equals operator"
  end

  # Boolean
  test "should validate boolean event rule with is not operator" do
    rule.ruleable = boolean_property
    rule.operator = "Is not"
    rule.value = false
    rule.data = { operator: rule.operator, value: rule.value }.stringify_keys

    assert rule.valid?, "Event rule with boolean 'is not' operator should be valid"
    assert rule.save, "Failed to save a valid boolean event rule with is not operator"
  end

  test "should validate boolean event rule with is operator" do
    rule.ruleable = boolean_property
    rule.operator = "Is"
    rule.value = true
    rule.data = { operator: rule.operator, value: rule.value }.stringify_keys

    assert rule.valid?, "Event rule with boolean 'is' operator should be valid"
    assert rule.save, "Failed to save a valid boolean event rule with is operator"
  end

  # Datetime
  test "should validate datetime event rule with after operator" do
    rule.ruleable = datetime_property
    rule.operator = "After"
    rule.value = "2024-01-01T00:00:00+00:00"
    rule.data = { operator: rule.operator, value: rule.value }.stringify_keys

    assert rule.valid?, "Event rule with datetime 'after' operator should be valid"
    assert rule.save, "Failed to save a valid datetime event rule with after operator"
  end

  test "should validate datetime event rule within range" do
    rule.ruleable = datetime_property
    rule.operator = "Within range"
    rule.from = "2023-01-01T00:00:00+00:00"
    rule.to = "2023-12-31T23:59:59+00:00"
    rule.inclusive = true
    rule.data = { operator: rule.operator, from: rule.from, to: rule.to, inclusive: rule.inclusive }.stringify_keys

    assert rule.valid?, "Event rule with datetime 'within range' operator should be valid"
    assert rule.save, "Failed to save a valid datetime event rule with within range operator"
  end

  # Missing operator
  test "should be invalid without an operator" do
    rule.ruleable = numeric_trait
    rule.data = { value: 30 }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid without an operator"
    assert_includes rule.errors[:data], "Missing operator in data"
  end

  # Invalid operator for numeric
  test "should be invalid with invalid numeric operator" do
    rule.ruleable = numeric_trait
    rule.operator = "InvalidOperator"
    rule.value = 30
    rule.data = { operator: rule.operator, value: rule.value }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid with invalid numeric operator"
    assert_includes rule.errors[:operator], "Invalid numeric operator 'InvalidOperator'"
  end

  # Invalid operator for text
  test "should be invalid with invalid text operator" do
    rule.ruleable = text_trait
    rule.operator = "InvalidOperator"
    rule.value = "Some Text"
    rule.data = { operator: rule.operator, value: rule.value }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid with invalid text operator"
    assert_includes rule.errors[:operator], "Invalid text operator 'InvalidOperator'"
  end

  # Invalid operator for boolean
  test "should be invalid with invalid boolean operator" do
    rule.ruleable = boolean_trait
    rule.operator = "InvalidOperator"
    rule.value = true
    rule.data = { operator: rule.operator, value: rule.value }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid with invalid boolean operator"
    assert_includes rule.errors[:operator], "Invalid boolean operator 'InvalidOperator'"
  end

  # Invalid operator for datetime
  test "should be invalid with invalid datetime operator" do
    rule.ruleable = datetime_trait
    rule.operator = "InvalidOperator"
    rule.value = "2023-10-25T23:48:46+00:00"
    rule.data = { operator: rule.operator, value: rule.value }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid with invalid datetime operator"
    assert_includes rule.errors[:operator], "Invalid datetime operator 'InvalidOperator'"
  end

  # Missing numeric value
  test "should be invalid without numeric value for Greater than operator" do
    rule.ruleable = numeric_trait
    rule.operator = "Greater than"
    rule.data = { operator: rule.operator }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid without numeric value"
    assert_includes rule.errors[:value], "Numeric value must be present for Greater than"
  end

  # Invalid range without from and to for numeric
  test "should be invalid without from and to for numeric within range operator" do
    rule.ruleable = numeric_trait
    rule.operator = "Within range"
    rule.inclusive = true
    rule.data = { operator: rule.operator, inclusive: rule.inclusive }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid without from and to for within range"
    assert_includes rule.errors[:from], "'from' and 'to' must be numeric for within range operator"
  end

  # Invalid ISO8601 datetime
  test "should be invalid with invalid datetime format for before operator" do
    rule.ruleable = datetime_trait
    rule.operator = "Before"
    rule.value = "invalid-datetime"
    rule.data = { operator: rule.operator, value: rule.value }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid with invalid datetime format"
    assert_includes rule.errors[:value], "Value must be a valid ISO8601 datetime string"
  end

  # Invalid case_sensitive for text rule
  test "should be invalid with invalid case_sensitive value for text rule" do
    rule.ruleable = text_trait
    rule.operator = "Equals"
    rule.value = "Some Text"
    rule.data = { operator: rule.operator, value: rule.value, case_sensitive: "invalid" }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid with invalid case_sensitive"
    assert_includes rule.errors[:case_sensitive], "case_sensitive must be true or false"
  end

  # Invalid inclusive value for range operator
  test "should be invalid with invalid inclusive value for within range operator" do
    rule.ruleable = numeric_trait
    rule.operator = "Within range"
    rule.from = 20
    rule.to = 30
    rule.inclusive = nil
    rule.data = { operator: rule.operator, from: rule.from, to: rule.to, inclusive: rule.inclusive }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid with invalid inclusive value"
    assert_includes rule.errors[:inclusive], "'inclusive' key must be true or false for within range operator"
  end

  test "should be invalid with unknown ruleable type" do
    rule.ruleable_type = "Account"
    rule.operator = "Equals"
    rule.value = "Some Value"
    rule.data = { operator: rule.operator, value: rule.value }.stringify_keys

    assert_not rule.valid?, "Rule should be invalid with unknown ruleable type"
    assert_includes rule.errors[:ruleable_type], "Unknown ruleable type"
  end
end
