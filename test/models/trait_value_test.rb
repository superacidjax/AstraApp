require "test_helper"

class TraitValueTest < ActiveSupport::TestCase
  def person
    @person ||= Fabricate(:person)
  end

  def trait
    @trait ||= Fabricate(:trait)
  end

  def trait_value
    @trait_value ||= Fabricate.build(:trait_value, person: person, trait: trait)
  end

  test "should be valid with valid attributes" do
    assert trait_value.valid?, "TraitValue should be valid with valid attributes"
  end

  test "should not be valid without data" do
    trait_value.data = nil
    assert_not trait_value.valid?, "TraitValue should not be valid without data"
    assert trait_value.errors[:data].any?, "There should be an error for the missing data"
  end

  test "should not be valid without person" do
    trait_value.person = nil
    assert_not trait_value.valid?, "TraitValue should not be valid without a person"
    assert trait_value.errors[:person].any?, "There should be an error for the missing person"
  end

  test "should not be valid without trait" do
    trait_value.trait = nil
    assert_not trait_value.valid?, "TraitValue should not be valid without a trait"
    assert trait_value.errors[:trait].any?, "There should be an error for the missing trait"
  end
end
