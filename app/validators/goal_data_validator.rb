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
      state = data[state_name]
      next unless state

      items = state["items"]
      unless items.is_a?(Array)
        record.errors.add(:data, "#{state_name}: Items must be an array")
        next
      end

      validate_items(record, items, state_name)
    end
  end

  private

  def validate_items(record, items, context)
    if items.length < 1
      record.errors.add(:data, "#{context}: Must contain at least one item.")
      return
    end

    items.each_with_index do |item, index|
      validate_item(record, item, index, items.length, context)
    end
  end

  def validate_item(record, item, index, total_items, context)
    is_last_item = index == total_items - 1

    # Validate operator
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

    # Validate item type
    case item["type"]
    when "rule"
      if item["rule_id"].blank?
        record.errors.add(:data, "#{context}: Rule ID is required.")
      end
    when "rule_group"
      validate_rule_group(record, item, context)
    else
      record.errors.add(:data, "#{context}: Invalid item type '#{item['type']}'.")
    end
  end

  def validate_rule_group(record, item, context)
    items = item["items"]
    unless items.is_a?(Array)
      record.errors.add(:data, "#{context}: Rule group items must be an array.")
      return
    end

    if items.length < 2
      record.errors.add(:data, "#{context} -> Rule Group: Rule group must contain at least two items.") # Updated message
    end

    validate_items(record, items, "#{context} -> Rule Group")
  end
end
