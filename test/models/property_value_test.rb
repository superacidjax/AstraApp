require "test_helper"

class PropertyValueTest < ActiveSupport::TestCase
  setup do
    @property_value = Fabricate(:property_value)
  end

  test "fabricated property_value should be valid" do
    assert @property_value.valid?, "Fabricated property_value is not valid"
  end

  test "should not save property_value without data" do
    property_value = Fabricate.build(:property_value, data: nil)
    assert_not property_value.save, "Saved the property_value without data"
    assert property_value.errors[:data].any?,
           "There should be an error for missing data"
  end

  test "should not save property_value without property" do
    property_value = Fabricate.build(:property_value, property: nil)
    assert_not property_value.save, "Saved the property_value without a property"
    assert property_value.errors[:property].any?,
           "There should be an error for missing property"
  end

  test "should save valid property_value" do
    property_value = Fabricate.build(:property_value, data: "Sample Data")
    assert property_value.save, "Failed to save a valid property_value"
  end
end
