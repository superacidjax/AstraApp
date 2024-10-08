class GoalComponent < ViewComponent::Base
  def initialize(goal:)
    @goal = goal
  end

  def success_rate
    rate = @goal.success_rate
    (rate == 0 || rate == 100) ? "#{rate.to_i}%" : "#{rate.round(2)}%"
  end

  def format_rules(state)
    items = @goal.data[state]&.dig("items")
    items.present? ? format_items(items) : ""
  end

  private

  def format_items(items)
    items.each_with_index.map do |item, index|
      formatted_item = format_item(item)
      if last_item?(items, index) && item["operator"].present?
        "#{formatted_item} #{item['operator']}"
      else
        formatted_item
      end
    end.join(" ")
  end

  def format_item(item)
    if item["type"] == "rule_group"
      "(#{format_items(item['items'])})"
    else
      item["name"].strip
    end
  end

  def last_item?(items, index)
    index < items.size - 1
  end
end
