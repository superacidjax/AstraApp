require "test_helper"

class TraitValueTest < ActiveSupport::TestCase
  setup do
    @trait_value = trait_values(:one) # Assuming you have a fixture named :one for trait_values
  end

  test "fixture trait_value should be valid" do
    assert @trait_value.valid?, "Fixture trait_value is not valid"
  end

  test "should not save trait_value without data" do
    trait_value = TraitValue.new(person: people(:one), trait: traits(:one))
    assert_not trait_value.save, "Saved the trait_value without data"
    assert trait_value.errors[:data].any?, "There should be an error for the missing data"
  end

  test "should not save trait_value without person" do
    trait_value = TraitValue.new(data: "Sample Data", trait: traits(:one))
    assert_not trait_value.save, "Saved the trait_value without a person"
    assert trait_value.errors[:person].any?, "There should be an error for the missing person"
  end

  test "should not save trait_value without trait" do
    trait_value = TraitValue.new(data: "Sample Data", person: people(:one))
    assert_not trait_value.save, "Saved the trait_value without a trait"
    assert trait_value.errors[:trait].any?, "There should be an error for the missing trait"
  end
end
