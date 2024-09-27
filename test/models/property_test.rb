require "test_helper"

class PropertyTest < ActiveSupport::TestCase
  setup do
    @property = properties(:one)
  end

  test "fixture property should be valid" do
    assert @property.valid?, "Fixture property is not valid"
  end

  test "should not save property without a name" do
    property = Property.new(is_active: true, account: accounts(:one), value_type: :text)
    assert_not property.save, "Saved the property without a name"
    assert property.errors[:name].any?, "There should be an error for missing name"
  end

  test "should not save property without is_active" do
    property = Property.new(name: "Test Property", account: accounts(:one), value_type: :text)
    property.is_active = nil
    assert_not property.save, "Saved the property without an is_active value"
    assert property.errors[:is_active].any?, "There should be an error for missing is_active"
  end

  test "should not save property without account" do
    property = Property.new(name: "Test Property", is_active: true, value_type: :text)
    assert_not property.save, "Saved the property without an account"
    assert property.errors[:account].any?, "There should be an error for missing account"
  end

  test "should not save property without value_type" do
    property = Property.new(name: "Test Property", is_active: true, account: accounts(:one))
    property.value_type = nil
    assert_not property.save, "Saved the property without a value_type"
    assert property.errors[:value_type].any?, "There should be an error for missing value_type"
  end

  test "should allow valid value_type" do
    property = Property.new(name: "Test Property", is_active: true, account: accounts(:one), value_type: :numeric)
    assert property.save, "Failed to save a valid property with value_type :numeric"
  end

  test "should reject invalid value_type" do
    property = Property.new(name: "Test Property", is_active: true, account: accounts(:one))
    assert_raises ArgumentError do
      property.value_type = :invalid_type
    end
  end

  test "should correctly handle value_type enums" do
    property = Property.new(name: "Test Property", is_active: true, account: accounts(:one), value_type: :boolean)
    assert_equal "boolean", property.value_type, "Property value_type should be 'boolean'"
    property.value_type = :datetime
    assert_equal "datetime", property.value_type, "Property value_type should be 'datetime'"
  end
end
