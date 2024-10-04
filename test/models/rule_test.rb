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
end
