require "test_helper"

class EventRuleTest < ActiveSupport::TestCase
  def fabricate_property(value_type, event)
    case value_type
    when "numeric"
      Fabricate(:numeric_property, event: event)
    when "text"
      Fabricate(:text_property, event: event)
    when "boolean"
      Fabricate(:boolean_property, event: event)
    when "datetime"
      Fabricate(:datetime_property, event: event)
    else
      Fabricate(:property, value_type: value_type, event: event)
    end
  end

  test "should be valid with numeric operator 'Greater than'" do
    event = Fabricate(:event)
    property = fabricate_property("numeric", event)
    event_rule = Fabricate.build(:numeric_event_rule, ruleable: property)
    event_rule.operator = "Greater than"
    event_rule.value = "50"
    assert event_rule.valid?, "EventRule with 'Greater than' operator should be valid"
  end

  test "should be valid with numeric operator 'Less than'" do
    event = Fabricate(:event)
    property = fabricate_property("numeric", event)
    event_rule = Fabricate.build(:numeric_event_rule, ruleable: property)
    event_rule.operator = "Less than"
    event_rule.value = "20"
    assert event_rule.valid?, "EventRule with 'Less than' operator should be valid"
  end

  test "should be valid with numeric operator 'Equal to'" do
    event = Fabricate(:event)
    property = fabricate_property("numeric", event)
    event_rule = Fabricate.build(:numeric_event_rule, ruleable: property)
    event_rule.operator = "Equal to"
    event_rule.value = "30"
    assert event_rule.valid?, "EventRule with 'Equal to' operator should be valid"
  end

  test "should be valid with numeric operator 'Within range'" do
    event = Fabricate(:event)
    property = fabricate_property("numeric", event)
    event_rule = Fabricate.build(:numeric_event_rule, ruleable: property)
    event_rule.operator = "Within range"
    event_rule.from = "20"
    event_rule.to = "40"
    event_rule.inclusive = true
    assert event_rule.valid?, "EventRule with 'Within range' operator should be valid"
  end

  test "should be invalid with numeric operator 'Within range' missing from and to" do
    event = Fabricate(:event)
    property = fabricate_property("numeric", event)
    event_rule = Fabricate.build(:numeric_event_rule, ruleable: property)
    event_rule.operator = "Within range"
    assert_not event_rule.valid?, "EventRule should be invalid without from and to for 'Within range'"
    assert_includes event_rule.errors["from"],
      "'from' must be numeric for 'Within range'"
    assert_includes event_rule.errors["to"],
      "'to' must be numeric for 'Within range'"
  end

  test "should be invalid with numeric operator 'Greater than' missing value" do
    event = Fabricate(:event)
    property = fabricate_property("numeric", event)
    event_rule = Fabricate.build(:numeric_event_rule, ruleable: property)
    event_rule.operator = "Greater than"
    event_rule.value = nil
    assert_not event_rule.valid?, "EventRule should be invalid without value for 'Greater than'"
    assert_includes event_rule.errors["value"],
      "Numeric value must be present"
  end

  test "should be invalid with numeric operator 'Contains'" do
    event = Fabricate(:event)
    property = fabricate_property("numeric", event)
    event_rule = Fabricate.build(:numeric_event_rule, ruleable: property)
    event_rule.operator = "Contains"
    event_rule.value = "test"
    assert_not event_rule.valid?, "EventRule should be invalid with 'Contains' operator for numeric property"
    assert_includes event_rule.errors["operator"],
      "Invalid numeric operator 'Contains'"
  end

  test "should be valid with text operator 'Equals'" do
    event = Fabricate(:event)
    property = fabricate_property("text", event)
    event_rule = Fabricate.build(:text_event_rule, ruleable: property)
    event_rule.operator = "Equals"
    event_rule.value = "Example"
    event_rule.data["case_sensitive"] = true
    assert event_rule.valid?, "EventRule with 'Equals' operator should be valid"
  end

  test "should be valid with text operator 'Not equals'" do
    event = Fabricate(:event)
    property = fabricate_property("text", event)
    event_rule = Fabricate.build(:text_event_rule, ruleable: property)
    event_rule.operator = "Not equals"
    event_rule.value = "Example"
    event_rule.data["case_sensitive"] = false
    assert event_rule.valid?, "EventRule with 'Not equals' operator should be valid"
  end

  test "should be valid with text operator 'Contains'" do
    event = Fabricate(:event)
    property = fabricate_property("text", event)
    event_rule = Fabricate.build(:text_event_rule, ruleable: property)
    event_rule.operator = "Contains"
    event_rule.value = "test"
    assert event_rule.valid?, "EventRule with 'Contains' operator should be valid"
  end

  test "should be valid with text operator 'Does not contain'" do
    event = Fabricate(:event)
    property = fabricate_property("text", event)
    event_rule = Fabricate.build(:text_event_rule, ruleable: property)
    event_rule.operator = "Does not contain"
    event_rule.value = "test"
    assert event_rule.valid?, "EventRule with 'Does not contain' operator should be valid"
  end

  test "should be invalid with text operator 'Equals' missing value" do
    event = Fabricate(:event)
    property = fabricate_property("text", event)
    event_rule = Fabricate.build(:text_event_rule, ruleable: property)
    event_rule.operator = "Equals"
    event_rule.value = nil
    assert_not event_rule.valid?, "EventRule should be invalid without value for 'Equals'"
    assert_includes event_rule.errors["value"],
      "Text value must be present"
  end

  test "should be invalid with text operator 'Contains' missing value" do
    event = Fabricate(:event)
    property = fabricate_property("text", event)
    event_rule = Fabricate.build(:text_event_rule, ruleable: property)
    event_rule.operator = "Contains"
    event_rule.value = nil
    assert_not event_rule.valid?, "EventRule should be invalid without value for 'Contains'"
    assert_includes event_rule.errors["value"],
      "Text value must be present"
  end

  test "should be invalid with text operator 'Equals' invalid case_sensitive" do
    event = Fabricate(:event)
    property = fabricate_property("text", event)
    event_rule = Fabricate.build(:text_event_rule, ruleable: property)
    event_rule.operator = "Equals"
    event_rule.value = "Test"
    event_rule.data["case_sensitive"] = "maybe"
    assert_not event_rule.valid?, "EventRule should be invalid with invalid case_sensitive value"
    assert_includes event_rule.errors["case_sensitive"],
      "case_sensitive must be true or false"
  end

  test "should be valid with boolean operator 'Is'" do
    event = Fabricate(:event)
    property = fabricate_property("boolean", event)
    event_rule = Fabricate.build(:boolean_event_rule, ruleable: property)
    event_rule.operator = "Is"
    event_rule.value = "true"
    assert event_rule.valid?, "EventRule with 'Is' operator should be valid"
  end

  test "should be valid with boolean operator 'Is not'" do
    event = Fabricate(:event)
    property = fabricate_property("boolean", event)
    event_rule = Fabricate.build(:boolean_event_rule, ruleable: property)
    event_rule.operator = "Is not"
    event_rule.value = "false"
    assert event_rule.valid?, "EventRule with 'Is not' operator should be valid"
  end

  test "should be invalid with boolean operator 'Is' missing value" do
    event = Fabricate(:event)
    property = fabricate_property("boolean", event)
    event_rule = Fabricate.build(:boolean_event_rule, ruleable: property)
    event_rule.operator = "Is"
    event_rule.value = nil
    assert_not event_rule.valid?, "EventRule should be invalid without value for 'Is'"
    assert_includes event_rule.errors["value"],
      "Boolean value must be true or false"
  end

  test "should be invalid with boolean operator 'Is not' invalid value" do
    event = Fabricate(:event)
    property = fabricate_property("boolean", event)
    event_rule = Fabricate.build(:boolean_event_rule, ruleable: property)
    event_rule.operator = "Is not"
    event_rule.value = "not_boolean"
    assert_not event_rule.valid?, "EventRule should be invalid with non-boolean value"
    assert_includes event_rule.errors["value"],
      "Boolean value must be true or false"
  end

  test "should be valid with datetime operator 'Before'" do
    event = Fabricate(:event)
    property = fabricate_property("datetime", event)
    event_rule = Fabricate.build(:datetime_event_rule, ruleable: property)
    event_rule.operator = "Before"
    event_rule.value = "2024-12-01T12:00:00Z"
    assert event_rule.valid?, "EventRule with 'Before' operator should be valid"
  end

  test "should be valid with datetime operator 'After'" do
    event = Fabricate(:event)
    property = fabricate_property("datetime", event)
    event_rule = Fabricate.build(:datetime_event_rule, ruleable: property)
    event_rule.operator = "After"
    event_rule.value = "2024-12-01T12:00:00Z"
    assert event_rule.valid?, "EventRule with 'After' operator should be valid"
  end

  test "should be valid with datetime operator 'Within range'" do
    event = Fabricate(:event)
    property = fabricate_property("datetime", event)
    event_rule = Fabricate.build(:datetime_event_rule, ruleable: property)
    event_rule.operator = "Within range"
    event_rule.from = "2024-01-01T00:00:00Z"
    event_rule.to = "2024-12-31T23:59:59Z"
    event_rule.inclusive = false
    assert event_rule.valid?, "EventRule with 'Within range' operator should be valid"
  end

  test "should be invalid with datetime operator 'Before' invalid value" do
    event = Fabricate(:event)
    property = fabricate_property("datetime", event)
    event_rule = Fabricate.build(:datetime_event_rule, ruleable: property)
    event_rule.operator = "Before"
    event_rule.value = "invalid-date"
    assert_not event_rule.valid?, "EventRule should be invalid with non-ISO8601 datetime value"
    assert_includes event_rule.errors["value"],
      "Value must be a valid ISO8601 datetime string"
  end

  test "should be invalid with datetime operator 'Within range' missing from and to" do
    event = Fabricate(:event)
    property = fabricate_property("datetime", event)
    event_rule = Fabricate.build(:datetime_event_rule, ruleable: property)
    event_rule.operator = "Within range"
    event_rule.from = nil
    event_rule.to = nil
    event_rule.inclusive = true
    assert_not event_rule.valid?, "EventRule should be invalid without from and to for 'Within range'"
    assert_includes event_rule.errors["from"],
      "'from' must be datetime for 'Within range'"
    assert_includes event_rule.errors["to"],
      "'to' must be datetime for 'Within range'"
  end

  test "should be invalid with datetime operator 'Within range' invalid inclusive" do
    event = Fabricate(:event)
    property = fabricate_property("datetime", event)
    event_rule = Fabricate.build(:datetime_event_rule, ruleable: property)
    event_rule.operator = "Within range"
    event_rule.from = "2024-01-01T00:00:00Z"
    event_rule.to = "2024-12-31T23:59:59Z"
    event_rule.inclusive = nil
    assert_not event_rule.valid?, "EventRule should be invalid with invalid inclusive value"
    assert_includes event_rule.errors["inclusive"],
      "'inclusive' key must be true or false"
  end

  test "should be invalid with operator not allowed for value_type" do
    event = Fabricate(:event)
    property = fabricate_property("numeric", event)
    event_rule = Fabricate.build(:numeric_event_rule, ruleable: property)
    event_rule.operator = "Contains"
    event_rule.value = "test"
    assert_not event_rule.valid?, "EventRule should be invalid with operator not allowed for value_type"
    assert_includes event_rule.errors["operator"],
      "Invalid numeric operator 'Contains'"
  end

  # Occurrence-Based EventRule Validations

  test "should be valid with occurrence operator 'Has occurred'" do
    event = Fabricate(:event)
    property = fabricate_property("numeric", event)
    event_rule = Fabricate.build(:occurrence_event_rule, ruleable: property)
    event_rule.occurrence_operator = "Has occurred"
    event_rule.time_unit = "days"
    event_rule.time_value = 10
    event_rule.datetime_from = "2024-01-01T00:00:00Z"
    event_rule.datetime_to = "2024-12-31T23:59:59Z"
    event_rule.occurrence_inclusive = true
    assert event_rule.valid?, "Occurrence EventRule with 'Has occurred' operator should be valid"
  end

  test "should be valid with occurrence operator 'Has not occurred'" do
    event = Fabricate(:event)
    property = fabricate_property("text", event)
    event_rule = Fabricate.build(:occurrence_event_rule, ruleable: property)
    event_rule.occurrence_operator = "Has not occurred"
    event_rule.time_unit = "hours"
    event_rule.time_value = 5
    event_rule.datetime_from = "2024-01-01T00:00:00Z"
    event_rule.datetime_to = "2024-12-31T23:59:59Z"
    event_rule.occurrence_inclusive = false
    assert event_rule.valid?, "Occurrence EventRule with 'Has not occurred' operator should be valid"
  end

  test "should be valid with occurrence operator 'Has occurred' without time or date" do
    event = Fabricate(:event)
    property = fabricate_property("boolean", event)
    event_rule = Fabricate.build(:occurrence_event_rule, ruleable: property)
    event_rule.occurrence_operator = "Has occurred"
    assert event_rule.valid?, "Occurrence EventRule should be invalid with missing fields"
  end

  test "should be invalid with invalid occurrence operator" do
    event = Fabricate(:event)
    property = fabricate_property("text", event)
    event_rule = Fabricate.build(:occurrence_event_rule, ruleable: property)
    event_rule.occurrence_operator = "Invalid Operator"
    event_rule.time_unit = "days"
    event_rule.time_value = 10
    event_rule.datetime_from = "2024-01-01T00:00:00Z"
    event_rule.datetime_to = "2024-12-31T23:59:59Z"
    event_rule.occurrence_inclusive = true
    assert_not event_rule.valid?, "Occurrence EventRule should be invalid with invalid operator"
    assert_includes event_rule.errors["occurrence_operator"],
      "Invalid occurrence 'Invalid Operator'"
  end

  # Data Structure Validation

  test "should be invalid without any operator" do
    event = Fabricate(:event)
    property = fabricate_property("text", event)
    event_rule = Fabricate.build(:event_rule, ruleable: property)
    event_rule.operator = nil
    event_rule.occurrence_operator = nil
    assert_not event_rule.valid?, "EventRule should be invalid without any operator"
    assert_includes event_rule.errors["data"],
      "Missing operator in data"
  end

  test "should be invalid with both property and occurrence operators" do
    event = Fabricate(:event)
    property = fabricate_property("numeric", event)
    event_rule = Fabricate.build(:numeric_event_rule, ruleable: property)
    event_rule.occurrence_operator = "Has occurred"
    event_rule.operator = "Greater than"
    event_rule.value = "50"
    assert_not event_rule.valid?, "EventRule should be invalid with both property and occurrence operators"
    assert_includes event_rule.errors["data"],
      "Cannot have both property_operator and occurrence_operator"
  end

  test "should not include occurrence-related fields in property-based EventRule" do
    event = Fabricate(:event)
    property = fabricate_property("numeric", event)
    event_rule = Fabricate.build(:numeric_event_rule, ruleable: property)
    event_rule.operator = "Greater than"
    event_rule.value = "50"
    event_rule.from = nil
    event_rule.to = nil
    event_rule.inclusive = nil
    assert event_rule.valid?, "EventRule should be valid without occurrence-related fields"
    assert_nil event_rule.occurrence_operator, "occurrence_operator should be nil"
    assert_nil event_rule.time_unit, "time_unit should be nil"
    assert_nil event_rule.time_value, "time_value should be nil"
    assert_nil event_rule.datetime_from, "datetime_from should be nil"
    assert_nil event_rule.datetime_to, "datetime_to should be nil"
    assert_nil event_rule.occurrence_inclusive, "occurrence_inclusive should be nil"
  end

  test "should not include property-based fields in occurrence-based EventRule" do
    event = Fabricate(:event)
    property = fabricate_property("boolean", event)
    event_rule = Fabricate.build(:occurrence_event_rule, ruleable: property)
    event_rule.occurrence_operator = "Has occurred"
    event_rule.time_unit = "days"
    event_rule.time_value = 10
    event_rule.datetime_from = "2024-01-01T00:00:00Z"
    event_rule.datetime_to = "2024-12-31T23:59:59Z"
    event_rule.occurrence_inclusive = true
    assert event_rule.valid?, "Occurrence EventRule should be valid without property-based fields"
    assert_nil event_rule.operator, "operator should be nil"
    assert_nil event_rule.value, "value should be nil"
    assert_nil event_rule.from, "from should be nil"
    assert_nil event_rule.to, "to should be nil"
    assert_nil event_rule.inclusive, "inclusive should be nil"
  end
end
