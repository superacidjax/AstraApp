class PersonRuleDataValidator < ActiveModel::Validator
  ALLOWED_OPERATORS = {
    "numeric" => [ "greater_than", "less_than", "equal_to", "within_range" ],
    "text" => [ "equals", "not_equals", "contains", "does_not_contain" ],
    "boolean" => [ "is", "is_not" ],
    "datetime" => [ "before", "after", "within_range" ]
  }.freeze

  def validate(record)
    validate_trait_rule(record)
  end

  private

  def validate_trait_rule(record)
    value_type = record.ruleable.value_type
    operator = record.operator

    unless valid_operator?(value_type, operator)
      record.errors.add(:operator, "Invalid #{value_type} operator '#{operator}'")
    end

    send("validate_#{value_type}_trait", record)
  end

  def valid_operator?(value_type, operator)
    ALLOWED_OPERATORS[value_type].include?(operator)
  end

  # Numeric trait validation
  def validate_numeric_trait(record)
    if record.operator == "within_range"
      validate_range(record, :numeric)
    else
      validate_presence_of_value(record, :numeric)
    end
  end

  # Text trait validation
  def validate_text_trait(record)
    validate_presence_of_value(record, :text)
    validate_case_sensitivity(record)
  end

  # Boolean trait validation
  def validate_boolean_trait(record)
    validate_boolean_value(record)
  end

  # Datetime trait validation
  def validate_datetime_trait(record)
    if record.operator == "within_range"
      validate_range(record, :datetime)
    else
      validate_datetime_value(record)
    end
  end

  def validate_presence_of_value(record, value_type)
    value = case value_type
    when :numeric then numeric_or_nil(record.value)
    else record.value
    end

    unless value.present?
      record.errors.add(:value,
                        "#{value_type.capitalize} value must be present for #{record.operator}")
    end
  end

  def validate_case_sensitivity(record)
    if record.data.key?("case_sensitive") &&
        ![ true, false ].include?(record.data["case_sensitive"])
      record.errors.add(:case_sensitive, "case_sensitive must be true or false")
    end
  end

  def validate_boolean_value(record)
    value = boolean_or_nil(record.value)
    unless [ true, false ].include?(value)
      record.errors.add(:value, "Boolean value must be true or false")
    end
  end

  def validate_range(record, value_type)
    from, to = cast_range_values(record, value_type)

    if from.nil? || to.nil?
      record.errors.add(:from,
                        "'from' and 'to' must be #{value_type} for 'within range' operator")
    end

    validate_inclusive_key(record)
  end

  def cast_range_values(record, value_type)
    case value_type
    when :numeric
      [ numeric_or_nil(record.from), numeric_or_nil(record.to) ]
    when :datetime
      [ valid_iso8601?(record.from), valid_iso8601?(record.to) ]
    end
  end

  def validate_inclusive_key(record)
    unless [ true, false ].include?(record.inclusive)
      record.errors.add(:inclusive,
                        "'inclusive' key must be true or false for 'within range' operator")
    end
  end

  def validate_datetime_value(record)
    unless valid_iso8601?(record.value)
      record.errors.add(:value, "Value must be a valid ISO8601 datetime string")
    end
  end

  # Helper methods
  def boolean_or_nil(value)
    return true if [ true, "t", "true" ].include?(value)
    return false if [ false, "f", "false" ].include?(value)
    nil
  end

  def numeric_or_nil(value)
    return value if value.is_a?(Numeric)
    Float(value) rescue nil
  end

  def valid_iso8601?(value)
    DateTime.iso8601(value)
    true
  rescue ArgumentError
    false
  end
end
