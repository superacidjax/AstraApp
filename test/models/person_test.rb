require "test_helper"

class PersonTest < ActiveSupport::TestCase
  def account
    @account ||= Fabricate(:account)
  end

  def person
    @person ||= Fabricate.build(:person, account: account)
  end

  test "should not be valid without account" do
    person = Fabricate.build(:person, account: nil)
    assert_not person.valid?, "Person should not be valid without an account"
    assert_includes person.errors[:account], "must exist", "Missing error for account presence"
  end

  test "should be valid with valid attributes" do
    assert person.valid?, "Person should be valid with valid attributes"
  end

  test "should have validation error on account" do
    person = Fabricate.build(:person, account: nil)
    assert person.invalid?, "Person without an account should be invalid"
    assert_includes person.errors[:account], "must exist", "Missing validation error for account"
  end

  test "should not be valid without client_timestamp" do
    person = Fabricate.build(:person, client_timestamp: nil)
    assert_not person.valid?, "Person should not be valid without a client timestamp"
    assert_includes person.errors[:client_timestamp], "can't be blank", "Missing validation error for client timestamp"
  end

  test "should save person with valid attributes" do
    person = Fabricate.build(:person, account: account)
    assert person.save, "Failed to save the person with valid attributes"
  end

  test "should have many client applications through client_application_people" do
    client_application = Fabricate(:client_application, account: account)
    person = Fabricate(:person, account: account)
    person.client_applications << client_application
    assert_respond_to person, :client_applications, "Person does not have a 'client_applications' association"
    assert_equal 1, person.client_applications.size, "Person should have 1 client application"
  end
end
