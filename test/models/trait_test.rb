require "test_helper"

class TraitTest < ActiveSupport::TestCase
  setup do
    @trait = traits(:one) # Assuming you have a fixture named :one for traits
  end

  test "fixture trait should be valid" do
    assert @trait.valid?, "Fixture trait is not valid"
  end

  test "should not save trait without a name" do
    trait = Trait.new(is_active: true, account: accounts(:one), value_type: :text)
    assert_not trait.save, "Saved the trait without a name"
  end

  test "should not save trait without is_active" do
    trait = Trait.new(name: "Test Trait", account: accounts(:one), value_type: :text)
    trait.is_active = nil
    assert_not trait.save, "Saved the trait without an is_active value"
    assert trait.errors[:is_active].any?, "There should be an error for the is_active"
  end

  test "should not save trait without account" do
    trait = Trait.new(name: "Test Trait", is_active: true, value_type: :text)
    assert_not trait.save, "Saved the trait without an account"
    assert trait.errors[:account].any?, "There should be an error for the account"
  end

  test "should not save trait without value_type" do
    trait = Trait.new(name: "Test Trait", is_active: true, account: accounts(:one))
    trait.value_type = nil
    assert_not trait.save, "Saved the trait without a value_type"
    assert trait.errors[:value_type].any?, "There should be an error for the value_type"
  end

  test "should allow valid value_type" do
    trait = Trait.new(name: "Test Trait", is_active: true, account: accounts(:one), value_type: :numeric)
    assert trait.save, "Failed to save a valid trait with value_type :numeric"
  end

  test "should reject invalid value_type" do
    trait = Trait.new(name: "Test Trait", is_active: true, account: accounts(:one))
    assert_raises ArgumentError do
      trait.value_type = :invalid_type
    end
  end

  test "should correctly handle value_type enums" do
    trait = Trait.new(name: "Test Trait", is_active: true, account: accounts(:one), value_type: :boolean)
    assert_equal "boolean", trait.value_type, "Trait value_type should be 'boolean'"
    trait.value_type = :datetime
    assert_equal "datetime", trait.value_type, "Trait value_type should be 'datetime'"
  end
end
