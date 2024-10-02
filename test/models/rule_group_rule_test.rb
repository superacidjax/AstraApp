# test/models/rule_group_rule_test.rb
require "test_helper"

class RuleGroupRuleTest < ActiveSupport::TestCase
  setup do
    @account = accounts(:one)
    @rule_group = rule_groups(:main_group)
    @rule = rules(:one)
    @other_rule = rules(:two)
  end

  test "should be valid with valid rule and rule_group" do
    rule_group_rule = rule_group_rules(:one)
    assert rule_group_rule.valid?
  end

  test "should be invalid without a rule" do
    rule_group_rule = RuleGroupRule.new(
      rule_group: @rule_group
    )
    assert_not rule_group_rule.valid?
    assert_includes rule_group_rule.errors[:rule], "must exist"
  end

  test "should be invalid without a rule_group" do
    rule_group_rule = RuleGroupRule.new(
      rule: @rule
    )
    assert_not rule_group_rule.valid?
    assert_includes rule_group_rule.errors[:rule_group], "must exist"
  end

  test "should enforce uniqueness of rule scoped to rule_group" do
    # this is already within the fixure
    duplicate_association = RuleGroupRule.new(
      rule: @rule,
      rule_group: @rule_group
    )

    assert_not duplicate_association.valid?
    assert_includes duplicate_association.errors[:rule_id], "is already associated with this rule group"
  end

  test "should allow the same rule in different rule_groups" do
    other_rule_group = rule_groups(:another_main_group)
    rule_group_rule = RuleGroupRule.new(
      rule: @rule,
      rule_group: other_rule_group
    )
    assert rule_group_rule.valid?
  end

  test "should allow different rules in the same rule_group" do
    # Association one exists in the fixture already
    association_two = RuleGroupRule.new(
      rule: @other_rule,
      rule_group: @rule_group
    )

    assert association_two.valid?
  end
end
