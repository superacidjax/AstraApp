require "test_helper"

class FlowTest < ActiveSupport::TestCase
  def account
    @account ||= Fabricate(:account)
  end

  def different_account
    @different_account ||= Fabricate(:account)
  end

  def flow
    @flow ||= Fabricate(:flow, account: account)
  end

  test "should not be valid without name" do
    flow = Fabricate.build(:flow, account: account, name: nil)
    assert_not flow.valid?, "Flow should not be valid without a name"
    assert flow.errors[:name].any?, "There should be an error for the name"
  end

  test "should be valid with valid attributes" do
    assert flow.valid?, "Flow should be valid with valid attributes"
  end

  test "should not save flow with duplicate name within the same account" do
    flow
    duplicate_flow = Fabricate.build(:flow, account: account, name: flow.name)
    assert_not duplicate_flow.save, "Saved the flow with a duplicate name within the same account"
  end

  test "should have validation error on name when name is not unique within the account" do
    flow
    duplicate_flow = Fabricate.build(:flow, account: account, name: flow.name)
    assert duplicate_flow.invalid?, "Flow with duplicate name within the same account should be invalid"
    assert duplicate_flow.errors[:name].any?, "There should be an error for duplicate name within the account"
  end

  test "should save flow with duplicate name in different accounts" do
    flow
    flow_with_duplicate_name = Fabricate.build(:flow, account: different_account, name: flow.name)
    assert flow_with_duplicate_name.save, "Did not save the flow with a duplicate name in a different account"
  end
end
