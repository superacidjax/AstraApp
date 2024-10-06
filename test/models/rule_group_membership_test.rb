require "test_helper"

class RuleGroupMembershipTest < ActiveSupport::TestCase
  def parent_group
    @parent_group ||= Fabricate(:rule_group)
  end

  def child_group
    @child_group ||= Fabricate(:rule_group)
  end

  def other_child_group
    @other_child_group ||= Fabricate(:rule_group)
  end

  test "should be valid with valid parent_group, child_group, and operator" do
    membership = Fabricate.build(:rule_group_membership, parent_group: parent_group, child_group: child_group, operator: "AND")
    assert membership.valid?
  end

  test "should be invalid without a parent_group" do
    membership = Fabricate.build(:rule_group_membership, parent_group: nil, child_group: child_group, operator: "OR")
    assert_not membership.valid?
    assert_includes membership.errors[:parent_group], "must exist"
  end

  test "should be invalid without a child_group" do
    membership = Fabricate.build(:rule_group_membership, parent_group: parent_group, child_group: nil, operator: "AND")
    assert_not membership.valid?
    assert_includes membership.errors[:child_group], "must exist"
  end

  test "should enforce uniqueness of child_group scoped to parent_group" do
    Fabricate(:rule_group_membership, parent_group: parent_group, child_group: child_group, operator: "OR")
    duplicate_membership = Fabricate.build(:rule_group_membership, parent_group: parent_group, child_group: child_group, operator: "OR")

    assert_not duplicate_membership.valid?
    assert_includes duplicate_membership.errors[:child_group_id], "is already added to this parent group"
  end

  test "should allow the same child_group in different parent_groups" do
    other_parent_group = Fabricate(:rule_group)
    membership = Fabricate.build(:rule_group_membership, parent_group: other_parent_group, child_group: child_group, operator: "AND")
    assert membership.valid?
  end

  test "should allow different child_groups in the same parent_group" do
    membership_one = Fabricate(:rule_group_membership, parent_group: parent_group, child_group: child_group, operator: "AND")
    membership_two = Fabricate.build(:rule_group_membership, parent_group: parent_group, child_group: other_child_group, operator: "OR")

    assert membership_one.valid?
    assert membership_two.valid?
  end

  test "should be invalid without operator when not the last item" do
    # The last_item? method should be false because the operator is nil.
    membership = Fabricate.build(:rule_group_membership, parent_group: parent_group, child_group: child_group, operator: nil)

    # Simulate a non-last item scenario where an operator is required.
    def membership.last_item?
      false
    end

    assert_not membership.valid?
    assert_includes membership.errors[:operator], "can't be blank"
  end

  test "should be valid without operator if last item" do
    membership = Fabricate.build(:rule_group_membership, parent_group: parent_group, child_group: child_group, operator: nil)

    # Simulate the last item scenario where no operator is required.
    def membership.last_item?
      true
    end

    assert membership.valid?
  end

  test "should be invalid with an operator not in [AND, OR, NOT]" do
    membership = Fabricate.build(:rule_group_membership, parent_group: parent_group, child_group: child_group, operator: "INVALID")
    assert_not membership.valid?
    assert_includes membership.errors[:operator], "is not included in the list"
  end

  test "should be valid with operator 'AND', 'OR', or 'NOT'" do
    %w[AND OR NOT].each do |operator|
      membership = Fabricate.build(:rule_group_membership, parent_group: parent_group, child_group: child_group, operator: operator)
      assert membership.valid?, "#{operator} should be valid"
    end
  end
end
