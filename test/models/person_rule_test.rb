require "test_helper"

class PersonRuleTest < ActiveSupport::TestCase
  def account
    @account ||= Fabricate(:account)
  end

  def person_rule
    @person_rule ||= Fabricate.build(:person_rule, account: account)
  end

  def fabricate_trait(value_type)
    case value_type
    when "numeric"
      Fabricate(:numeric_trait, account: account)
    when "boolean"
      Fabricate(:boolean_trait, account: account)
    when "datetime"
      Fabricate(:datetime_trait, account: account)
    else
      Fabricate(:text_trait, account: account)
    end
  end

  test "should be valid with numeric operator 'Greater than'" do
    trait = fabricate_trait("numeric")
    person_rule.ruleable = trait
    person_rule.operator = "Greater than"
    person_rule.value = "50"
    assert person_rule.valid?, "PersonRule with 'Greater than' operator should be valid"
  end

  test "should be valid with numeric operator 'Less than'" do
    trait = fabricate_trait("numeric")
    person_rule.ruleable = trait
    person_rule.operator = "Less than"
    person_rule.value = "20"
    person_rule.from = nil
    person_rule.to = nil
    person_rule.inclusive = nil
    assert person_rule.valid?, "PersonRule with 'Less than' operator should be valid"
  end

  test "should be valid with numeric operator 'Equal to'" do
    trait = fabricate_trait("numeric")
    person_rule.ruleable = trait
    person_rule.operator = "Equal to"
    person_rule.value = "30"
    person_rule.from = nil
    person_rule.to = nil
    person_rule.inclusive = nil
    assert person_rule.valid?, "PersonRule with 'Equal to' operator should be valid"
  end

  test "should be valid with numeric operator 'Within range'" do
    trait = fabricate_trait("numeric")
    person_rule.ruleable = trait
    person_rule.operator = "Within range"
    person_rule.value = nil
    person_rule.from = "20"
    person_rule.to = "40"
    person_rule.inclusive = true
    assert person_rule.valid?, "PersonRule with 'Within range' operator should be valid"
  end

  test "should be valid with text operator 'Equals'" do
    trait = fabricate_trait("text")
    person_rule.ruleable = trait
    person_rule.operator = "Equals"
    person_rule.value = "Example"
    person_rule.from = nil
    person_rule.to = nil
    person_rule.inclusive = nil
    person_rule.data[:case_sensitive] = true
    assert person_rule.valid?, "PersonRule with 'Equals' operator should be valid"
  end

  test "should be valid with text operator 'Not equals'" do
    trait = fabricate_trait("text")
    person_rule.ruleable = trait
    person_rule.operator = "Not equals"
    person_rule.value = "Example"
    person_rule.from = nil
    person_rule.to = nil
    person_rule.inclusive = nil
    person_rule.data[:case_sensitive] = false
    assert person_rule.valid?, "PersonRule with 'Not equals' operator should be valid"
  end

  test "should be valid with text operator 'Contains'" do
    trait = fabricate_trait("text")
    person_rule.ruleable = trait
    person_rule.operator = "Contains"
    person_rule.value = "test"
    person_rule.from = nil
    person_rule.to = nil
    person_rule.inclusive = nil
    assert person_rule.valid?, "PersonRule with 'Contains' operator should be valid"
  end

  test "should be valid with text operator 'Does not contain'" do
    trait = fabricate_trait("text")
    person_rule.ruleable = trait
    person_rule.operator = "Does not contain"
    person_rule.value = "test"
    person_rule.from = nil
    person_rule.to = nil
    person_rule.inclusive = nil
    assert person_rule.valid?, "PersonRule with 'Does not contain' operator should be valid"
  end

  test "should be valid with boolean operator 'Is'" do
    trait = fabricate_trait("boolean")
    person_rule.ruleable = trait
    person_rule.operator = "Is"
    person_rule.value = "true"
    person_rule.from = nil
    person_rule.to = nil
    person_rule.inclusive = nil
    assert person_rule.valid?, "PersonRule with 'Is' operator should be valid"
  end

  test "should be valid with boolean operator 'Is not'" do
    trait = fabricate_trait("boolean")
    person_rule.ruleable = trait
    person_rule.operator = "Is not"
    person_rule.value = "false"
    person_rule.from = nil
    person_rule.to = nil
    person_rule.inclusive = nil
    assert person_rule.valid?, "PersonRule with 'Is not' operator should be valid"
  end

  test "should be valid with datetime operator 'Before'" do
    trait = fabricate_trait("datetime")
    person_rule.ruleable = trait
    person_rule.operator = "Before"
    person_rule.value = "2024-12-01T12:00:00Z"
    person_rule.from = nil
    person_rule.to = nil
    person_rule.inclusive = nil
    assert person_rule.valid?, "PersonRule with 'Before' operator should be valid"
  end

  test "should be valid with datetime operator 'After'" do
    trait = fabricate_trait("datetime")
    person_rule.ruleable = trait
    person_rule.operator = "After"
    person_rule.value = "2024-12-01T12:00:00Z"
    person_rule.from = nil
    person_rule.to = nil
    person_rule.inclusive = nil
    assert person_rule.valid?, "PersonRule with 'After' operator should be valid"
  end

  test "should be valid with datetime operator 'Within range'" do
    trait = fabricate_trait("datetime")
    person_rule.ruleable = trait
    person_rule.operator = "Within range"
    person_rule.value = nil
    person_rule.from = "2024-01-01T00:00:00Z"
    person_rule.to = "2024-12-31T23:59:59Z"
    person_rule.inclusive = false
    assert person_rule.valid?, "PersonRule with 'Within range' operator should be valid"
  end

  test "should be invalid with operator not allowed for value_type" do
    trait = fabricate_trait("numeric")
    person_rule.ruleable = trait
    person_rule.operator = "Contains"
    person_rule.value = "test"
    assert_not person_rule.valid?, "PersonRule should be invalid with operator not allowed for value_type"
    assert_includes person_rule.errors[:operator], "Invalid numeric operator 'Contains'"
  end

  test "should be invalid without value for non-range operator" do
    trait = fabricate_trait("text")
    person_rule.ruleable = trait
    person_rule.operator = "Equals"
    person_rule.value = nil
    assert_not person_rule.valid?, "PersonRule should be invalid without value for non-range operator"
    assert_includes person_rule.errors[:value], "Text value must be present for Equals"
  end

  test "should be invalid without from and to for 'Within range' operator" do
    trait = fabricate_trait("numeric")
    person_rule.ruleable = trait
    person_rule.operator = "Within range"
    person_rule.inclusive = true
    assert_not person_rule.valid?, "PersonRule should be invalid without from and to for 'Within range'"
    assert_includes person_rule.errors[:from],
                    "'from' and 'to' must be numeric for 'within range' operator"
  end

  test "should be invalid if inclusive is not true or false for 'Within range' operator" do
    trait = fabricate_trait("numeric")
    person_rule.ruleable = trait
    person_rule.operator = "Within range"
    person_rule.from = "10"
    person_rule.to = "20"
    person_rule.inclusive = nil
    assert_not person_rule.valid?, "PersonRule should be invalid if inclusive is not true or false"
    assert_includes person_rule.errors[:inclusive],
                    "'inclusive' key must be true or false for 'within range' operator"
  end

  test "should be invalid if case_sensitive is not true or false for text trait" do
    trait = fabricate_trait("text")
    person_rule.ruleable = trait
    person_rule.operator = "Equals"
    person_rule.value = "Test"
    person_rule.data["case_sensitive"] = "maybe"
    assert_not person_rule.valid?, "PersonRule should be invalid if case_sensitive is not true or false"
    assert_includes person_rule.errors["case_sensitive"],
                    "case_sensitive must be true or false"
  end

  test "should be invalid with non-boolean value for boolean trait" do
    trait = fabricate_trait("boolean")
    person_rule.ruleable = trait
    person_rule.operator = "Is"
    person_rule.value = "not a boolean"
    assert_not person_rule.valid?, "PersonRule should be invalid with non-boolean value for boolean trait"
    assert_includes person_rule.errors[:value], "Boolean value must be true or false"
  end

  test "should be invalid with non-ISO8601 value for datetime trait" do
    trait = fabricate_trait("datetime")
    person_rule.ruleable = trait
    person_rule.operator = "After"
    person_rule.value = "invalid-date"
    assert_not person_rule.valid?, "PersonRule should be invalid with non-ISO8601 value for datetime trait"
    assert_includes person_rule.errors[:value],
                    "Value must be a valid ISO8601 datetime string"
  end

  test "should not include occurrence-related fields" do
    trait = fabricate_trait("numeric")
    person_rule.ruleable = trait
    person_rule.operator = "Greater than"
    person_rule.value = "50"
    assert person_rule.valid?, "PersonRule should be valid without occurrence-related fields"
    assert_nil person_rule.occurrence_operator, "occurrence_operator should be nil"
    assert_nil person_rule.time_unit, "time_unit should be nil"
    assert_nil person_rule.time_value, "time_value should be nil"
    assert_nil person_rule.datetime_from, "datetime_from should be nil"
    assert_nil person_rule.datetime_to, "datetime_to should be nil"
    assert_nil person_rule.occurrence_inclusive, "occurrence_inclusive should be nil"
  end
end
