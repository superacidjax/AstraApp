require "test_helper"

class RuleGroupMembershipTest < ActiveSupport::TestCase
  setup do
    @account = accounts(:one)
    @parent_group = rule_groups(:main_group)
    @child_group = rule_groups(:nested_group)
    @other_child_group = rule_groups(:another_nested_group)
  end

  test "should be valid with valid parent_group and child_group" do
    membership = rule_group_memberships(:one)
    assert membership.valid?
  end

  test "should be invalid without a parent_group" do
    membership = RuleGroupMembership.new(
      child_group: @child_group
    )
    assert_not membership.valid?
    assert_includes membership.errors[:parent_group], "must exist"
  end

  test "should be invalid without a child_group" do
    membership = RuleGroupMembership.new(
      parent_group: @parent_group
    )
    assert_not membership.valid?
    assert_includes membership.errors[:child_group], "must exist"
  end

  test "should enforce uniqueness of child_group scoped to parent_group" do
    # the original membership is in the fixture alreay
    duplicate_membership = RuleGroupMembership.new(
      parent_group: @parent_group,
      child_group: @child_group
    )

    assert_not duplicate_membership.valid?
    assert_includes duplicate_membership.errors[:child_group_id], "is already added to this parent group"
  end

  test "should allow the same child_group in different parent_groups" do
    other_parent_group = rule_groups(:another_main_group)
    membership = RuleGroupMembership.new(
      parent_group: other_parent_group,
      child_group: @child_group
    )
    assert membership.valid?
  end

  test "should allow different child_groups in the same parent_group" do
    membership_one = rule_group_memberships(:one)
    membership_two = RuleGroupMembership.new(
      parent_group: @parent_group,
      child_group: @other_child_group
    )

    assert membership_one.valid?
    assert membership_two.valid?
  end
end
