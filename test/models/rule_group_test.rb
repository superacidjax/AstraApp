require "test_helper"

class RuleGroupTest < ActiveSupport::TestCase
  setup do
    @account = accounts(:one)
    @rule = rules(:one)
    @nested_rule_group = rule_groups(:nested_group)
    @rule_group = rule_groups(:main_group)
  end

  test "should be valid with a name and data" do
    assert @rule_group.valid?
  end

  test "should be invalid without a name" do
    @rule_group.name = nil
    assert_not @rule_group.valid?
    assert_includes @rule_group.errors[:name], "can't be blank"
  end

  test "should be invalid without data" do
    @rule_group.data = nil
    assert_not @rule_group.valid?
    assert_includes @rule_group.errors[:data], "must contain at least one rule or rule group"
  end

  test "should be invalid with empty data" do
    @rule_group.data = {}
    assert_not @rule_group.valid?
    assert_includes @rule_group.errors[:data], "must contain at least one rule or rule group"
  end

  test "should be valid with at least one rule in data" do
    @rule_group.data = {
      "items" => [
        {
          "type" => "rule",
          "rule_id" => @rule.id,
          "operator" => nil
        }
      ]
    }
    assert @rule_group.valid?
  end

  test "should be valid with at least one nested rule group in data" do
    assert @rule_group.valid?
  end

  test "should correctly parse data items" do
    items = @rule_group.data["items"]
    assert_equal 1, items.length
    first_item = items.first
    assert_equal "rule_group", first_item["type"]
    assert_equal @nested_rule_group.id, first_item["rule_group_id"]
  end

  test "must_have_rule_or_group validation should fail if data is empty" do
    @rule_group.data = { "items" => [] }
    assert_not @rule_group.valid?
    assert_includes @rule_group.errors[:data], "must contain at least one rule or rule group"
  end

  test "must_have_rule_or_group validation should pass with a valid data" do
    assert @rule_group.valid?
  end

  test "should belong to an account" do
    assert_equal @account, @rule_group.account
  end

  test "should have accessible account through rule group" do
    assert @rule_group.respond_to?(:account)
  end
end
