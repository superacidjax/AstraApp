class RuleDataValidator < ActiveModel::Validator
  ALLOWED_NUMERIC_OPERATORS = [ "Greater than", "Less than", "Equal to", "Within range" ].freeze
  ALLOWED_TEXT_OPERATORS = [ "Equals", "Not equals", "Contains", "Does not contain" ].freeze
  ALLOWED_BOOLEAN_OPERATORS = [ "Is", "Is not" ].freeze
  ALLOWED_DATETIME_OPERATORS = [ "Before", "After", "Within range" ].freeze

  def validate(record)
    case record.ruleable_type
    when "Trait"
      validate_trait_based_rule(record)
    when "Property"
      validate_property_based_rule(record)
    else
      record.errors.add(:ruleable_type, "Unknown ruleable type")
    end
  end

  private

  # Trait-based rule validation
  def validate_trait_based_rule(record)
    validate_data_structure(record)
    value_type = record.ruleable.value_type

    case value_type
    when "numeric"
      validate_numeric_rule(record)
    when "text"
      validate_text_rule(record)
    when "boolean"
      validate_boolean_rule(record)
    when "datetime"
      validate_datetime_rule(record)
    else
      record.errors.add(:data, "Invalid value type for trait-based rule")
    end
  end

  # Property-based rule validation
  def validate_property_based_rule(record)
    validate_data_structure(record)
    value_type = record.ruleable.value_type

    case value_type
    when "numeric"
      validate_numeric_rule(record)
    when "text"
      validate_text_rule(record)
    when "boolean"
      validate_boolean_rule(record)
    when "datetime"
      validate_datetime_rule(record)
    else
      record.errors.add(:data, "Invalid value type for property-based rule")
    end
  end

  def validate_data_structure(record)
    data = record.data
    unless data.is_a?(Hash)
      record.errors.add(:data, "Data must be a JSON object")
      return
    end

    unless data.key?("operator")
      record.errors.add(:data, "Missing operator in data")
    end
  end

  # Numeric rule validation
  def validate_numeric_rule(record)
    operator = record.operator

    unless ALLOWED_NUMERIC_OPERATORS.include?(operator)
      record.errors.add(:operator, "Invalid numeric operator '#{operator}'")
      return
    end

    # Convert string representations of numbers to actual Numeric types
    from = numeric_or_nil(record.from)
    to = numeric_or_nil(record.to)
    value = numeric_or_nil(record.value)

    case operator
    when "Greater than", "Less than", "Equal to"
      unless value.is_a?(Numeric)
        record.errors.add(:value, "Numeric value must be present for #{operator}")
      end
    when "Within range"
      unless from.is_a?(Numeric) && to.is_a?(Numeric)
        record.errors.add(:from, "'from' and 'to' must be numeric for within range operator")
      end
      unless record.inclusive.in?([ true, false ])
        record.errors.add(:inclusive, "'inclusive' key must be true or false for within range operator")
      end
    end
  end

  # Text rule validation
  def validate_text_rule(record)
    operator = record.operator

    unless ALLOWED_TEXT_OPERATORS.include?(operator)
      record.errors.add(:operator, "Invalid text operator '#{operator}'")
      return
    end

    unless record.value.is_a?(String)
      record.errors.add(:value, "Text value must be present for #{operator}")
    end

    if record.data.key?("case_sensitive") && ![ true, false ].include?(record.data["case_sensitive"])
      record.errors.add(:case_sensitive, "case_sensitive must be true or false for text operator")
    end
  end

  # Boolean rule validation

  def validate_boolean_rule(record)
    operator = record.operator

    unless ALLOWED_BOOLEAN_OPERATORS.include?(operator)
      record.errors.add(:operator, "Invalid boolean operator '#{operator}'")
      return
    end

    # Convert "t"/"f" or string representations to actual boolean values
    value = boolean_or_nil(record.value)

    unless [ true, false ].include?(value)
      record.errors.add(:value, "Boolean value must be true or false")
    end
  end

  # Helper method to handle string representations of booleans
  def boolean_or_nil(value)
    return true if value == true || value == "t" || value == "true"
    return false if value == false || value == "f" || value == "false"
    nil
  end

  # Datetime rule validation
  def validate_datetime_rule(record)
    operator = record.operator

    unless ALLOWED_DATETIME_OPERATORS.include?(operator)
      record.errors.add(:operator, "Invalid datetime operator '#{operator}'")
      return
    end

    case operator
    when "Before", "After"
      unless valid_iso8601?(record.value)
        record.errors.add(:value, "Value must be a valid ISO8601 datetime string")
      end
    when "Within range"
      unless valid_iso8601?(record.from) && valid_iso8601?(record.to)
        record.errors.add(:from, "'from' and 'to' must be valid ISO8601 datetime strings")
      end
      unless record.inclusive.in?([ true, false ])
        record.errors.add(:inclusive, "'inclusive' key must be true or false for within range operator")
      end
    end
  end

  # Helper method to convert strings to numeric if possible
  def numeric_or_nil(value)
    return value if value.is_a?(Numeric)

    Float(value) rescue nil
  end

  # Helper method to check if a string is a valid ISO8601 datetime
  def valid_iso8601?(value)
    DateTime.iso8601(value)
    true
  rescue ArgumentError
    false
  end
end
