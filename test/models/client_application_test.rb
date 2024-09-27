require "test_helper"

class ClientApplicationTest < ActiveSupport::TestCase
  setup do
    @account = accounts(:one)
    @client_application = client_applications(:one)
  end

  test "should not save client application without name" do
    client_application = ClientApplication.new(account: @account)
    assert_not client_application.save, "Saved the client application without a name"
  end

  test "fixture client application should be valid" do
    assert @client_application.valid?, "Fixture client application is not valid"
  end

  test "should have validation error on name when name is missing" do
    client_application = ClientApplication.new(account: @account)
    assert client_application.invalid?, "Client application without a name should be invalid"
    assert client_application.errors[:name].any?, "There should be an error for the name"
  end

  test "should not save client application with duplicate name within the same account" do
    duplicate_client_application = ClientApplication.new(account: @client_application.account, name: @client_application.name)
    assert_not duplicate_client_application.save, "Saved the client application with a duplicate name within the same account"
  end

  test "should have validation error on name when name is not unique within the account" do
    duplicate_client_application = ClientApplication.new(account: @client_application.account, name: @client_application.name)
    assert duplicate_client_application.invalid?, "Client application with duplicate name within the same account should be invalid"
    assert duplicate_client_application.errors[:name].any?, "There should be an error for duplicate name within the account"
  end

  test "should save client application with duplicate name in different accounts" do
    different_account = accounts(:two)
    client_application_with_duplicate_name = ClientApplication.new(account: different_account, name: @client_application.name)
    assert client_application_with_duplicate_name.save, "Did not save the client application with a duplicate name in a different account"
  end
end
