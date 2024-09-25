require "test_helper"

class PersonTest < ActiveSupport::TestCase
  setup do
    @person = people(:one)
  end

  test "should not save account without account" do
    person = Person.new
    assert_not person.save, "Saved the person without an account"
  end

  test "fixture person should be valid" do
    assert @person.valid?, "Fixture person is not valid"
  end

  test "should have validation error on account" do
    person = Person.new
    assert person.invalid?, "Person without an account should be invalid"
  end
end
