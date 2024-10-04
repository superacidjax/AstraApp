require "test_helper"

class RuleGroupTest < ActiveSupport::TestCase
  def account
    @account ||= Fabricate(:account)
  end

  def trait_rule
    @trait_rule ||= Fabricate(:trait_rule, account: account)
  end

  def property_rule
    @property_rule ||= Fabricate(:property_rule, account: account)
  end

  def rule_group
    @rule_group ||= Fabricate(:rule_group, account: account)
  end

  def nested_rule_group
    @nested_rule_group ||= Fabricate(:rule_group, account: account)
  end

  test "should be valid with a name and data" do
    assert rule_group.valid?
  end

  test "should be invalid without a name" do
    rule_group.name = nil
    assert_not rule_group.valid?
    assert_includes rule_group.errors[:name], "can't be blank"
  end

  test "should be invalid without data" do
    rule_group.data = nil
    assert_not rule_group.valid?
    assert_includes rule_group.errors[:data], "must contain at least one rule or rule group"
  end

  test "should be invalid with empty data" do
    rule_group.data = {}
    assert_not rule_group.valid?
    assert_includes rule_group.errors[:data], "must contain at least one rule or rule group"
  end

  test "should be valid with at least one trait rule in data" do
    rule_group.data = {
      "items" => [
        {
          "type" => "rule",
          "rule_id" => trait_rule.id,
          "operator" => nil
        }
      ]
    }
    assert rule_group.valid?
  end

  test "should be valid with at least one property rule in data" do
    rule_group.data = {
      "items" => [
        {
          "type" => "rule",
          "rule_id" => property_rule.id,
          "operator" => nil
        }
      ]
    }
    assert rule_group.valid?
  end

  test "should be valid with at least one nested rule group in data" do
    rule_group.data = {
      "items" => [
        {
          "type" => "rule_group",
          "rule_group_id" => nested_rule_group.id,
          "operator" => "AND"
        }
      ]
    }
    assert rule_group.valid?
  end

  test "should correctly parse data items" do
    rule_group.data = {
      "items" => [
        {
          "type" => "rule_group",
          "rule_group_id" => nested_rule_group.id,
          "operator" => "AND"
        }
      ]
    }
    items = rule_group.data["items"]
    assert_equal 1, items.length
    first_item = items.first
    assert_equal "rule_group", first_item["type"]
    assert_equal nested_rule_group.id, first_item["rule_group_id"]
  end

  test "must_have_rule_or_group validation should fail if data is empty" do
    rule_group.data = { "items" => [] }
    assert_not rule_group.valid?
    assert_includes rule_group.errors[:data], "must contain at least one rule or rule group"
  end

  test "must_have_rule_or_group validation should pass with valid data" do
    rule_group.data = {
      "items" => [
        {
          "type" => "rule",
          "rule_id" => trait_rule.id,
          "operator" => nil
        }
      ]
    }
    assert rule_group.valid?
  end

  test "should belong to an account" do
    assert_equal account, rule_group.account
  end

  test "should have accessible account through rule group" do
    assert rule_group.respond_to?(:account)
  end
end
