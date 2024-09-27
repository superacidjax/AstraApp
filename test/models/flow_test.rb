require "test_helper"

class FlowTest < ActiveSupport::TestCase
  setup do
    @account = accounts(:one)
    @flow = flows(:one)
  end

  test "should not save flow without name" do
    flow = Flow.new(account: @account)
    assert_not flow.save, "Saved the flow without a name"
  end

  test "fixture flow should be valid" do
    assert @flow.valid?, "Fixture flow is not valid"
  end

  test "should have validation error on name when name is missing" do
    flow = Flow.new(account: @account)
    assert flow.invalid?, "Flow without a name should be invalid"
    assert flow.errors[:name].any?, "There should be an error for the name"
  end

  test "should not save flow with duplicate name within the same account" do
    duplicate_flow = Flow.new(account: @flow.account, name: @flow.name)
    assert_not duplicate_flow.save, "Saved the flow with a duplicate name within the same account"
  end

  test "should have validation error on name when name is not unique within the account" do
    duplicate_flow = Flow.new(account: @flow.account, name: @flow.name)
    assert duplicate_flow.invalid?, "Flow with duplicate name within the same account should be invalid"
    assert duplicate_flow.errors[:name].any?, "There should be an error for duplicate name within the account"
  end

  test "should save flow with duplicate name in different accounts" do
    different_account = accounts(:two)
    flow_with_duplicate_name = Flow.new(account: different_account, name: @flow.name)
    assert flow_with_duplicate_name.save, "Did not save the flow with a duplicate name in a different account"
  end
end
