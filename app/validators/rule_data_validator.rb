class RuleDataValidator < ActiveModel::Validator
  ALLOWED_OPERATORS = {
    "numeric" => [ "Greater than", "Less than", "Equal to", "Within range" ],
    "text" => [ "Equals", "Not equals", "Contains", "Does not contain" ],
    "boolean" => [ "Is", "Is not" ],
    "datetime" => [ "Before", "After", "Within range" ]
  }.freeze

  def validate(record)
    ruleable_type = record.ruleable_type

    case ruleable_type
    when "Trait", "Property"
      validate_rule(record)
    else
      record.errors.add(:ruleable_type, "Unknown ruleable type")
    end
  end

  private

  def validate_rule(record)
    validate_data_structure(record)

    value_type = record.ruleable.value_type
    operator = record.operator

    unless ALLOWED_OPERATORS[value_type].include?(operator)
      record.errors.add(:operator, "Invalid #{value_type} operator '#{operator}'")
      return
    end

    case value_type
    when "numeric" then validate_numeric_rule(record)
    when "text" then validate_text_rule(record)
    when "boolean" then validate_boolean_rule(record)
    when "datetime" then validate_datetime_rule(record)
    end
  end

  def validate_data_structure(record)
    unless record.data.key?("operator")
      record.errors.add(:data, "Missing operator in data")
    end
  end

  def validate_numeric_rule(record)
    if record.operator == "Within range"
      validate_range(record, :numeric)
    else
      validate_presence_of_value(record, :numeric)
    end
  end

  def validate_text_rule(record)
    validate_presence_of_value(record, :text)
    validate_case_sensitivity(record)
  end

  def validate_boolean_rule(record)
    boolean_or_nil(record.value)
  end

  def validate_datetime_rule(record)
    if record.operator == "Within range"
      validate_range(record, :datetime)
    else
      validate_datetime_value(record)
    end
  end

  def validate_presence_of_value(record, value_type)
    value = record.value
    case value_type
    when :numeric
      value = numeric_or_nil(value)

      unless value.is_a?(Numeric)
        record.errors.add(:value, "Numeric value must be present for #{record.operator}")
      end
    end
  end

  def validate_case_sensitivity(record)
    if record.data.key?("case_sensitive") && ![ true, false ].include?(record.data["case_sensitive"])
      record.errors.add(:case_sensitive, "case_sensitive must be true or false")
    end
  end

  def validate_range(record, value_type)
    numeric_or_nil(record.from) && numeric_or_nil(record.to)
  end

  def validate_range(record, value_type)
    from, to = numeric_or_nil(record.from), numeric_or_nil(record.to)

    case value_type
    when :numeric
      unless from.is_a?(Numeric) && to.is_a?(Numeric)
        record.errors.add(:from, "'from' and 'to' must be numeric for within range operator")
      end
    end

    unless [ true, false ].include?(record.inclusive)
      record.errors.add(:inclusive, "'inclusive' key must be true or false for within range operator")
    end
  end

  def validate_datetime_value(record)
    unless valid_iso8601?(record.value)
      record.errors.add(:value, "Value must be a valid ISO8601 datetime string")
    end
  end

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
