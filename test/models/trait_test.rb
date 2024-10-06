require "test_helper"

class TraitTest < ActiveSupport::TestCase
  def account
    @account ||= Fabricate(:account)
  end

  def trait
    @trait ||= Fabricate.build(:trait, account: account)
  end

  test "should be valid with valid attributes" do
    assert trait.valid?, "Trait should be valid with valid attributes"
  end

  test "should not be valid without a name" do
    trait.name = nil
    assert_not trait.valid?, "Trait should not be valid without a name"
    assert trait.errors[:name].any?, "There should be an error for the missing name"
  end

  test "should not be valid without is_active" do
    trait.is_active = nil
    assert_not trait.valid?, "Trait should not be valid without is_active"
    assert trait.errors[:is_active].any?, "There should be an error for the missing is_active"
  end

  test "should not be valid without account" do
    trait.account = nil
    assert_not trait.valid?, "Trait should not be valid without an account"
    assert trait.errors[:account].any?, "There should be an error for the missing account"
  end

  test "should not be valid without value_type" do
    trait.value_type = nil
    assert_not trait.valid?, "Trait should not be valid without a value_type"
    assert trait.errors[:value_type].any?, "There should be an error for the missing value_type"
  end

  test "should allow valid value_type" do
    trait.value_type = :numeric
    assert trait.valid?, "Trait should be valid with value_type :numeric"
    assert trait.save, "Failed to save a valid trait with value_type :numeric"
  end

  test "should reject invalid value_type" do
    assert_raises ArgumentError do
      trait.value_type = :invalid_type
    end
  end

  test "should correctly handle value_type enums" do
    trait.value_type = :boolean
    assert_equal "boolean", trait.value_type, "Trait value_type should be 'boolean'"
    trait.value_type = :datetime
    assert_equal "datetime", trait.value_type, "Trait value_type should be 'datetime'"
  end
end
