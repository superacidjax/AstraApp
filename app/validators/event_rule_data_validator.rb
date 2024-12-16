class EventRuleDataValidator < ActiveModel::Validator
  ALLOWED_OPERATORS = {
    "numeric"   => [ "Greater than", "Less than", "Equal to", "Within range" ],
    "text"      => [ "Equals", "Not equals", "Contains", "Does not contain" ],
    "boolean"   => [ "Is", "Is not" ],
    "datetime"  => [ "Before", "After", "Within range" ],
    "occurrence"=> [ "Has occurred", "Has not occurred" ]
  }.freeze

  def validate(record)
    validate_data_structure(record)

    if record.occurrence_operator.present?
      validate_event_occurrence_rule(record)
    elsif record.operator.present?
      validate_event_property_rule(record)
    end
  end

  private

  def validate_data_structure(record)
    if record.operator.present? && record.occurrence_operator.present?
      record.errors.add(:data, "Cannot have both property_operator and occurrence_operator")
    elsif record.operator.blank? && record.occurrence_operator.blank?
      record.errors.add(:data, "Missing operator in data")
    end
  end

  def validate_event_property_rule(record)
    value_type = record.ruleable.value_type
    operator = record.operator

    unless valid_operator?(value_type, operator)
      record.errors.add(:operator, "Invalid #{value_type} operator '#{operator}'")
      return
    end

    send("validate_#{value_type}_property_rule", record)
  end

  def validate_event_occurrence_rule(record)
    occurrence = record.occurrence_operator

    unless ALLOWED_OPERATORS["occurrence"].include?(occurrence)
      record.errors.add("occurrence_operator", "Invalid occurrence '#{occurrence}'")
      return
    end

    # occurrence in a rule is allowed without specific datetimes
    # i.e. "Did this event ever happen"
    validate_datetime_range(record) if record.datetime_from.present? || record.datetime_to.present?
  end

  def valid_operator?(value_type, operator)
    ALLOWED_OPERATORS[value_type].include?(operator)
  end

  def validate_numeric_property_rule(record)
    if record.operator == "Within range"
      validate_range(record, "numeric", :from, :to)
    else
      validate_presence_of_value(record, "numeric", :value)
    end
  end

  def validate_text_property_rule(record)
    validate_presence_of_value(record, "text", :value)
    validate_case_sensitivity(record)
  end

  def validate_boolean_property_rule(record)
    validate_boolean_value(record, :value)
  end

  def validate_datetime_property_rule(record)
    if record.operator == "Within range"
      validate_range(record, "datetime", :from, :to)
    else
      validate_datetime_value(record, :value)
    end
  end

  def validate_range(record, value_type, from_key, to_key)
    from = record.send(from_key)
    to = record.send(to_key)

    if from.nil?
      record.errors.add("from", "'from' must be #{value_type} for 'Within range'")
    end

    if to.nil?
      record.errors.add(to_key, "'to' must be #{value_type} for 'Within range'")
    end

    if from.present? && to.present?
      validate_inclusive_key(record, :inclusive)
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
      record.errors.add("case_sensitive", "case_sensitive must be true or false")
    end
  end

  def validate_boolean_value(record, key)
    value = convert_to_boolean(record.send(key))
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
    inclusive = record.send(key)
    unless [ true, false ].include?(inclusive)
      record.errors.add(key, "'inclusive' key must be true or false")
    end
  end

  def valid_iso8601?(value)
    DateTime.iso8601(value)
    true
  rescue ArgumentError
    false
  end

  def convert_to_boolean(value)
    return true if value == "t" || value == "true" || value == true
    return false if value == "f" || value == "false" || value == false
    nil
  end

  def validate_datetime_range(record)
    from = record.datetime_from
    to = record.datetime_to

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
