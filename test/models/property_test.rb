# test/models/property_test.rb

require "test_helper"

class PropertyTest < ActiveSupport::TestCase
  def property
    @property ||= Fabricate.build(:property)
  end

  def event
    @event ||= Fabricate(:event)
  end

  test "should be valid with valid attributes" do
    assert property.valid?, "Property should be valid with valid attributes"
  end

  test "should not be valid without a name" do
    property.name = nil
    assert_not property.valid?, "Property should not be valid without a name"
    assert property.errors[:name].any?, "There should be an error for missing name"
  end

  test "should not be valid without is_active" do
    property.is_active = nil
    assert_not property.valid?, "Property should not be valid without is_active"
    assert property.errors[:is_active].any?, "There should be an error for missing is_active"
  end

  test "should not be valid without an event" do
    property.event = nil
    assert_not property.valid?, "Property should not be valid without an event"
    assert property.errors[:event].any?, "There should be an error for missing event"
  end

  test "should not be valid without value_type" do
    property.value_type = nil
    assert_not property.valid?, "Property should not be valid without value_type"
    assert property.errors[:value_type].any?, "There should be an error for missing value_type"
  end

  test "should allow valid value_type" do
    property.value_type = :numeric
    assert property.valid?, "Property should be valid with value_type :numeric"
    assert property.save, "Failed to save a valid property with value_type :numeric"
  end

  test "should reject invalid value_type" do
    assert_raises ArgumentError do
      property.value_type = :invalid_type
    end
  end

  test "should correctly handle value_type enums" do
    property.value_type = :boolean
    assert_equal "boolean", property.value_type, "Property value_type should be 'boolean'"

    property.value_type = :datetime
    assert_equal "datetime", property.value_type, "Property value_type should be 'datetime'"
  end
end
