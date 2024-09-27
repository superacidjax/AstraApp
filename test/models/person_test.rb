require "test_helper"

class PersonTest < ActiveSupport::TestCase
  setup do
    @person = people(:one)
  end

  test "should not save person without account" do
    person = Person.new(client_timestamp: Time.current)
    assert_not person.save, "Saved the person without an account"
    assert_includes person.errors[:account], "must exist", "Missing error for account presence"
  end

  test "fixture person should be valid" do
    assert @person.valid?, "Fixture person is not valid"
  end

  test "should have validation error on account" do
    person = Person.new(client_timestamp: Time.current)
    assert person.invalid?, "Person without an account should be invalid"
    assert_includes person.errors[:account], "must exist", "Missing validation error for account"
  end

  test "should not save person without client_timestamp" do
    person = Person.new(account: accounts(:one))
    assert_not person.save, "Saved the person without a client timestamp"
    assert_includes person.errors[:client_timestamp], "can't be blank", "Missing validation error for client timestamp"
  end

  test "should save person with valid attributes" do
    person = Person.new(
      account: accounts(:one),
      client_timestamp: Time.current,
      client_user_id: UUID7.generate
    )
    assert person.save, "Failed to save the person with valid attributes"
  end

  test "should have many client applications through client_application_people" do
    assert_respond_to @person, :client_applications, "Person does not have a 'client_applications' association"
    assert_equal 1, @person.client_applications.size, "Person should have 1 client application"
  end
end
