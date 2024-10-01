require "test_helper"

class PropertyValueTest < ActiveSupport::TestCase
  setup do
    @property_value = property_values(:one)
  end

  test "fixture property_value should be valid" do
    assert @property_value.valid?, "Fixture property_value is not valid"
  end

  test "should not save property_value without data" do
    property_value = PropertyValue.new(property: properties(:one))
    assert_not property_value.save, "Saved the property_value without data"
    assert property_value.errors[:data].any?, "There should be an error for missing data"
  end

  test "should not save property_value without property" do
    property_value = PropertyValue.new(data: "Sample Data")
    assert_not property_value.save, "Saved the property_value without a property"
    assert property_value.errors[:property].any?, "There should be an error for missing property"
  end

  test "should save valid property_value" do
    property_value = PropertyValue.new(data: "Sample Data", property: properties(:one))
    assert property_value.save, "Failed to save a valid property_value"
  end
end
