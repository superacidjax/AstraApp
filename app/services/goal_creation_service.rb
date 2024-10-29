class GoalCreationService
  def initialize(goal)
    @goal = goal
    @goal_data = @goal.data
    @goal_rules = []
    @goal_rule_groups = []
    @rule_group_memberships = []
    @rules = []
    @rule_groups = [] # Accumulate RuleGroups to insert them first
  end

  def call
    process_initial_state
    process_end_state
    insert_rule_groups
    insert_records
  end

  private

  def process_initial_state
    build_rules_and_groups(@goal_data["initial_state"]["items"], "initial")
  end

  def process_end_state
    build_rules_and_groups(@goal_data["end_state"]["items"], "end")
  end

  # Build rules and groups recursively
  def build_rules_and_groups(items, state, parent_group = nil)
    items.each do |item|
      if item["type"] == "rule_group"
        create_rule_group(item, state, parent_group)
      elsif item["type"] == "rule"
        create_rule(item, state, parent_group)
      end
    end
  end

  # Create RuleGroup and store GoalRuleGroup and Membership
  def create_rule_group(item, state, parent_group)
    rule_group = RuleGroup.new(name: item["name"], account: @goal.account, data: item["data"] || {})
    @rule_groups << rule_group
    @goal_rule_groups << GoalRuleGroup.new(goal: @goal, rule_group: rule_group, state: state)

    # Create membership later if parent group exists (when IDs are available)
    if parent_group
      @rule_group_memberships << { parent_group: parent_group, child_group: rule_group, operator: item["operator"] }
    end

    # Recursively build nested rules and groups
    build_rules_and_groups(item["items"], state, rule_group)
  end

  # Create Rule and store GoalRule
  def create_rule(item, state, parent_group)
    raise "Data missing for rule '#{item['name']}'" if item["data"].blank?

    rule = Rule.new(
      name: item["name"],
      account: @goal.account,
      ruleable: resolve_ruleable(item["ruleable"]),
      data: item["data"]
    )

    @rules << rule
    @goal_rules << GoalRule.new(goal: @goal, rule: rule, state: state)
  end

  # Insert RuleGroups first so that memberships can use the generated IDs
  def insert_rule_groups
    RuleGroup.import @rule_groups
  end

  # Insert all records using batch insert
  def insert_records
    binding.pry
    Rule.import @rules
    GoalRuleGroup.import @goal_rule_groups
    GoalRule.import @goal_rules

    # Now that the rule groups are inserted and have IDs, we can create memberships
    @rule_group_memberships.each do |membership|
      RuleGroupMembership.create!(
        parent_group_id: membership[:parent_group].id,
        child_group_id: membership[:child_group].id,
        operator: membership[:operator]
      )
    end
  end

  # Preload traits and properties to avoid redundant lookups
  def resolve_ruleable(ruleable_data)
    if ruleable_data["type"] == "trait"
      Trait.find(ruleable_data["id"])
    elsif ruleable_data["type"] == "property"
      Property.find(ruleable_data["id"])
    end
  end
end
