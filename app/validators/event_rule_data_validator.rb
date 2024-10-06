class EventRuleDataValidator < ActiveModel::Validator
  ALLOWED_OPERATORS = {
    "numeric" => [ "Greater than", "Less than", "Equal to", "Within range" ],
    "text" => [ "Equals", "Not equals", "Contains", "Does not contain" ],
    "boolean" => [ "Is", "Is not" ],
    "datetime" => [ "Before", "After", "Within range" ],
    "occurrence" => [ "Has occurred", "Has not occurred" ]
  }.freeze

  def validate(record)
    validate_data_structure(record)

    if record.occurrence_operator.present?
      validate_event_occurrence_rule(record)
    else
      validate_event_property_rule(record)
    end
  end

  private

  def validate_data_structure(record)
    unless record.data.key?("property_operator") || record.data.key?("occurrence_operator")
      record.errors.add(:data, "Missing operator in data")
    end
  end

  # Validation for Event Property-based rules (numeric, text, boolean, datetime)
  def validate_event_property_rule(record)
    value_type = record.ruleable.value_type
    operator = record.property_operator

    unless valid_operator?(value_type, operator)
      record.errors.add(:property_operator, "Invalid #{value_type} operator '#{operator}'")
      return
    end

    send("validate_#{value_type}_property_rule", record)
  end

  # Event occurrence-related rule validation
  def validate_event_occurrence_rule(record)
    occurrence = record.occurrence_operator

    unless ALLOWED_OPERATORS["occurrence"].include?(occurrence)
      record.errors.add(:occurrence_operator, "Invalid occurrence '#{occurrence}'")
      return
    end

    # Validate implied range (when `datetime_from` and `datetime_to` are present)
    validate_datetime_range(record) if record.datetime_from.present? || record.datetime_to.present?
  end

  def valid_operator?(value_type, operator)
    ALLOWED_OPERATORS[value_type].include?(operator)
  end

  # Numeric property validation
  def validate_numeric_property_rule(record)
    if record.property_operator == "Within range"
      validate_range(record, :numeric, :property_from, :property_to)
    else
      validate_presence_of_value(record, :numeric, :property_value)
    end
  end

  # Text property validation
  def validate_text_property_rule(record)
    validate_presence_of_value(record, :text, :property_value)
    validate_case_sensitivity(record)
  end

  # Boolean property validation
  def validate_boolean_property_rule(record)
    validate_boolean_value(record, :property_value)
  end

  # Datetime property validation
  def validate_datetime_property_rule(record)
    if record.property_operator == "Within range"
      validate_range(record, :datetime, :property_from, :property_to)
    else
      validate_datetime_value(record, :property_value)
    end
  end

  def validate_range(record, value_type, from_key, to_key)
    from, to = record.send(from_key), record.send(to_key)

    if from.nil?
      record.errors.add(from_key, "'from' must be #{value_type} for within range")
    end

    if to.nil?
      record.errors.add(to_key, "'to' must be #{value_type} for within range")
    end

    if from.present? && to.present?
      validate_inclusive_key(record, "property_inclusive")
    end
  end

  def validate_presence_of_value(record, value_type, key)
    value = record.send(key)
    unless value.present?
      record.errors.add(key, "#{value_type.capitalize} value must be present")
    end
  end

  def validate_case_sensitivity(record)
    if record.data.key?("case_sensitive") &&
        ![ true, false ].include?(record.data["case_sensitive"])
      record.errors.add(:case_sensitive, "case_sensitive must be true or false")
    end
  end

  def validate_boolean_value(record, key)
    value = record.send(key)
    if value == "t"
      value = true
    elsif value == "f"
      value = false
    end
    unless [ true, false ].include?(value)
      record.errors.add(key, "Boolean value must be true or false")
    end
  end

  def validate_datetime_value(record, key)
    value = record.send(key)
    unless valid_iso8601?(value)
      record.errors.add(key, "Value must be a valid ISO8601 datetime string")
    end
  end

  def validate_inclusive_key(record, key)
    unless [ true, false ].include?(record.send(key))
      record.errors.add(key, "'inclusive' key must be true or false")
    end
  end

  def valid_iso8601?(value)
    DateTime.iso8601(value)
    true
  rescue ArgumentError
    false
  end

  # Validate the implied range for occurrence rules with datetime_from and datetime_to
  def validate_datetime_range(record)
    from, to = record.datetime_from, record.datetime_to

    if from.nil?
      record.errors.add(:datetime_from, "'datetime_from' must be present for implied 'within range'")
    end

    if to.nil?
      record.errors.add(:datetime_to, "'datetime_to' must be present for implied 'within range'")
    end

    unless [ true, false ].include?(record.occurrence_inclusive)
      record.errors.add(:occurrence_inclusive, "'occurrence_inclusive' must be true or false")
    end
  end
end
