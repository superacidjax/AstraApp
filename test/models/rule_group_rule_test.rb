require "test_helper"

class RuleGroupRuleTest < ActiveSupport::TestCase
  setup do
    account = Fabricate(:account)
    @rule_group = Fabricate(:rule_group, account: account)
    @trait_rule = Fabricate(:trait_rule) # Assuming trait_rule or property_rule will be used
    @property_rule = Fabricate(:property_rule) # Assuming we have event-based rules
    @other_trait_rule = Fabricate(:trait_rule)
  end

  test "should be valid with valid rule and rule_group" do
    rule_group_rule = Fabricate(:rule_group_rule, rule: @trait_rule, rule_group: @rule_group)
    assert rule_group_rule.valid?
  end

  test "should be invalid without a rule" do
    rule_group_rule = Fabricate.build(:rule_group_rule, rule: nil, rule_group: @rule_group)
    assert_not rule_group_rule.valid?
    assert_includes rule_group_rule.errors[:rule], "must exist"
  end

  test "should be invalid without a rule_group" do
    rule_group_rule = Fabricate.build(:rule_group_rule, rule: @trait_rule, rule_group: nil)
    assert_not rule_group_rule.valid?
    assert_includes rule_group_rule.errors[:rule_group], "must exist"
  end

  test "should enforce uniqueness of rule scoped to rule_group" do
    Fabricate(:rule_group_rule, rule: @trait_rule, rule_group: @rule_group)
    duplicate_association = Fabricate.build(:rule_group_rule,
                                            rule: @trait_rule,
                                            rule_group: @rule_group)
    assert_not duplicate_association.valid?
    assert_includes duplicate_association.errors[:rule_id],
      "is already associated with this rule group"
  end

  test "should allow the same rule in different rule_groups" do
    other_rule_group = Fabricate(:rule_group)
    rule_group_rule = Fabricate.build(:rule_group_rule,
                                      rule: @trait_rule,
                                      rule_group: other_rule_group)
    assert rule_group_rule.valid?
  end

  test "should allow different rules in the same rule_group" do
    association_two = Fabricate.build(:rule_group_rule,
                                      rule: @other_trait_rule,
                                      rule_group: @rule_group)
    assert association_two.valid?
  end
end
