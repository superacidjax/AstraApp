require "test_helper"

class PropertyTest < ActiveSupport::TestCase
  setup do
    @property = properties(:one)
  end

  test "fixture property should be valid" do
    assert @property.valid?, "Fixture property is not valid"
  end

  test "should not save property without a name" do
    property = Property.new(is_active: true, event: events(:one), value_type: :text)
    assert_not property.save, "Saved the property without a name"
    assert property.errors[:name].any?, "There should be an error for missing name"
  end

  test "should not save property without is_active" do
    property = Property.new(name: "Test Property", event: events(:one), value_type: :text)
    property.is_active = nil
    assert_not property.save, "Saved the property without an is_active value"
    assert property.errors[:is_active].any?, "There should be an error for missing is_active"
  end

  test "should not save property without an event" do
    property = Property.new(name: "Test Property", is_active: true, value_type: :text)
    assert_not property.save, "Saved the property without an event"
    assert property.errors[:event].any?, "There should be an error for missing event"
  end

  test "should not save property without value_type" do
    property = Property.new(name: "Test Property", is_active: true, event: events(:one))
    property.value_type = nil
    assert_not property.save, "Saved the property without a value_type"
    assert property.errors[:value_type].any?, "There should be an error for missing value_type"
  end

  test "should allow valid value_type" do
    property = Property.new(name: "Test Property", is_active: true, event: events(:one), value_type: :numeric)
    assert property.save, "Failed to save a valid property with value_type :numeric"
  end

  test "should reject invalid value_type" do
    property = Property.new(name: "Test Property", is_active: true, event: events(:one))
    assert_raises ArgumentError do
      property.value_type = :invalid_type
    end
  end

  test "should correctly handle value_type enums" do
    property = Property.new(name: "Test Property", is_active: true, event: events(:one), value_type: :boolean)
    assert_equal "boolean", property.value_type, "Property value_type should be 'boolean'"
    property.value_type = :datetime
    assert_equal "datetime", property.value_type, "Property value_type should be 'datetime'"
  end
end
