class RuleDataValidator < ActiveModel::Validator
  ALLOWED_OPERATORS = {
    "numeric" => [ "Greater than", "Less than", "Equal to", "Within range" ],
    "text" => [ "Equals", "Not equals", "Contains", "Does not contain" ],
    "boolean" => [ "Is", "Is not" ],
    "datetime" => [ "Before", "After", "Within range" ]
  }.freeze

  def validate(record)
    ruleable_type = record.ruleable_type

    if %w[Trait Property].include?(ruleable_type)
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

    unless valid_operator?(value_type, operator)
      record.errors.add(:operator, "Invalid #{value_type} operator '#{operator}'")
      return
    end

    send("validate_#{value_type}_rule", record)
  end

  def valid_operator?(value_type, operator)
    ALLOWED_OPERATORS[value_type].include?(operator)
  end

  def validate_data_structure(record)
    record.errors.add(:data, "Missing operator in data") unless record.data.key?("operator")
  end

  # Numeric rule validation
  def validate_numeric_rule(record)
    if record.operator == "Within range"
      validate_range(record, :numeric)
    else
      validate_presence_of_value(record, :numeric)
    end
  end

  # Text rule validation
  def validate_text_rule(record)
    validate_presence_of_value(record, :text)
    validate_case_sensitivity(record)
  end

  # Boolean rule validation
  def validate_boolean_rule(record)
    validate_boolean_value(record)
  end

  # Datetime rule validation
  def validate_datetime_rule(record)
    if record.operator == "Within range"
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
      record.errors.add(:value, "#{value_type.capitalize} value must be present for #{record.operator}")
    end
  end

  def validate_case_sensitivity(record)
    return unless record.data.key?("case_sensitive")

    unless [ true, false ].include?(record.data["case_sensitive"])
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
      record.errors.add(:from, "'from' and 'to' must be #{value_type} for within range operator")
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
      record.errors.add(:inclusive, "'inclusive' key must be true or false for within range operator")
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
