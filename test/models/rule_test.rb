require "test_helper"

class RuleTest < ActiveSupport::TestCase
  setup do
    @account = accounts(:one)
    @rule = rules(:one)
  end

  test "should not save rule without name" do
    rule = Rule.new(account: @account)
    assert_not rule.save, "Saved the rule without a name"
  end

  test "fixture rule should be valid" do
    assert @rule.valid?, "Fixture rule is not valid"
  end

  test "should have validation error on name when name is missing" do
    rule = Rule.new(account: @account)
    assert rule.invalid?, "Rule without a name should be invalid"
    assert rule.errors[:name].any?, "There should be an error for the name"
  end

  test "should have validation error on rule_data when rule_data is missing" do
    rule = Rule.new(account: @account, name: "someName")
    assert rule.invalid?, "Rule without rule_data should be invalid"
    assert rule.errors[:rule_data].any?, "There should be an error for the rule_data"
  end

  test "should not save rule with duplicate name within the same account" do
    duplicate_rule = Rule.new(account: @rule.account, name: @rule.name)
    assert_not duplicate_rule.save, "Saved the rule with a duplicate name within the same account"
  end

  test "should have validation error on name when name is not unique within the account" do
    duplicate_rule = Rule.new(account: @rule.account, name: @rule.name)
    assert duplicate_rule.invalid?, "Rule with duplicate name within the same account should be invalid"
    assert duplicate_rule.errors[:name].any?, "There should be an error for duplicate name within the account"
  end

  test "should save rule with duplicate name in different accounts" do
    different_account = accounts(:two)
    rule_with_duplicate_name = Rule.new(
      account: different_account,
      name: @rule.name,
      rule_data: "someData"
    )
    assert rule_with_duplicate_name.save, "Did not save the rule with a duplicate name in a different account"
  end

  test "should return the correct account for the event" do
    client_application = client_applications(:one)
    event = Event.new(
      client_application: client_application,
      name: "Signed in",
      client_timestamp: Time.current.iso8601,
      client_user_id: UUID7.generate
    )

    assert_equal client_application.account, event.account, "Event should return the correct account through client_application"
  end
end
