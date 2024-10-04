class GoalDataValidator < ActiveModel::Validator
  ALLOWED_OPERATORS = %w[AND OR NOT].freeze

  def validate(record)
    begin
      data = JSON.parse(record.data)
    rescue JSON::ParserError
      record.errors.add(:data, "must be valid JSON")
      return
    end

    %w[initial_state end_state].each do |state_name|
      validate_state(record, data, state_name)
    end
  end

  private

  # Validate the entire state (initial_state or end_state)
  def validate_state(record, data, state_name)
    state = data[state_name]
    return unless state

    items = state["items"]
    unless items.is_a?(Array)
      record.errors.add(:data, "#{state_name}: Items must be an array")
      return
    end

    validate_items(record, items, state_name)
  end

  # Validate the list of items within a state or rule group
  def validate_items(record, items, context)
    if items.empty?
      record.errors.add(:data, "#{context}: Must contain at least one item.")
      return
    end

    items.each_with_index do |item, index|
      validate_item(record, item, index, items, context)
    end
  end

  # Validate an individual item (rule or rule group)
  def validate_item(record, item, index, items, context)
    is_last_item = index == items.length - 1

    validate_operator(record, item, is_last_item, context)
    validate_item_type(record, item, context)
  end

  # Validate the operator for the item
  def validate_operator(record, item, is_last_item, context)
    if is_last_item
      if item["operator"].present?
        record.errors.add(:data, "#{context}: Operator should not be present on the last item.")
      end
    else
      if item["operator"].blank?
        record.errors.add(:data, "#{context}: Operator is required between items.")
      elsif !ALLOWED_OPERATORS.include?(item["operator"])
        record.errors.add(:data, "#{context}: Operator '#{item['operator']}' is not valid. Allowed operators are #{ALLOWED_OPERATORS.join(', ')}.")
      end
    end
  end

  # Validate the type of the item (rule or rule group)
  def validate_item_type(record, item, context)
    case item["type"]
    when "rule"
      validate_rule(record, item, context)
    when "rule_group"
      validate_rule_group(record, item, context)
    else
      record.errors.add(:data, "#{context}: Invalid item type '#{item['type']}'.")
    end
  end

  # Validate a rule item
  def validate_rule(record, item, context)
    if item["rule_id"].blank?
      record.errors.add(:data, "#{context}: Rule ID is required.")
    end
  end

  # Validate a rule group item
  def validate_rule_group(record, item, context)
    items = item["items"]
    unless items.is_a?(Array)
      record.errors.add(:data, "#{context}: Rule group items must be an array.")
      return
    end

    if items.length < 2
      record.errors.add(:data, "#{context} -> Rule Group: Rule group must contain at least two items.")
    end

    validate_items(record, items, "#{context} -> Rule Group")
  end
end
