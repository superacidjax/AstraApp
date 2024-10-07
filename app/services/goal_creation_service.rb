class GoalCreationService
  def initialize(goal, data_json)
    @goal = goal
    @data_json = data_json
    @goal_data = JSON.parse(data_json)
  end

  def process
    # Process initial state rules and groups
    build_rules_and_groups(@goal_data["initial_state"]["items"], "initial")

    # Process end state rules and groups
    build_rules_and_groups(@goal_data["end_state"]["items"], "end")
  end

  private

  def build_rules_and_groups(items, state, parent_group = nil)
    items.each do |item|
      if item["type"] == "rule_group"
        rule_group = RuleGroup.create!(name: item["name"], account: @goal.account, data: item["data"] || {})
        GoalRuleGroup.create!(goal: @goal, rule_group: rule_group, state: state)

        if parent_group
          RuleGroupMembership.create!(
            parent_group_id: parent_group.id,
            child_group_id: rule_group.id,
            operator: item["operator"]
          )
        end

        build_rules_and_groups(item["items"], state, rule_group)

      elsif item["type"] == "rule"
        rule = Rule.create!(
          name: item["name"],
          account: @goal.account,
          ruleable: resolve_ruleable(item["ruleable"]),
          data: item["data"]
        )
        GoalRule.create!(goal: @goal, rule: rule, state: state)
      end
    end
  end

  def resolve_ruleable(ruleable_data)
    if ruleable_data["type"] == "trait"
      Trait.find_by(value_type: ruleable_data["value_type"])
    elsif ruleable_data["type"] == "property"
      Property.find_by(value_type: ruleable_data["value_type"])
    end
  end
end
