require "test_helper"

class ClientApplicationTest < ActiveSupport::TestCase
  def account
    @account ||= Fabricate(:account)
  end

  def client_application
    @client_application ||= Fabricate.build(:client_application, account: account)
  end

  def different_account
    @different_account ||= Fabricate(:account)
  end

  test "should be valid with valid attributes" do
    assert client_application.valid?, "Client application should be valid with valid attributes"
  end

  test "should not be valid without name" do
    client_application.name = nil

    assert_not client_application.valid?, "Client application should not be valid without a name"
    assert_includes client_application.errors[:name], "can't be blank"
  end

  test "should not be valid without account" do
    client_application.account = nil

    assert_not client_application.valid?, "Client application should not be valid without an account"
    assert_includes client_application.errors[:account], "must exist"
  end

  test "should not be valid with duplicate name within the same account" do
    Fabricate(:client_application, account: account, name: "Duplicate Name")
    duplicate_client_application = Fabricate.build(:client_application, account: account, name: "Duplicate Name")

    assert_not duplicate_client_application.valid?, "Client application should not be valid with a duplicate name within the same account"
    assert_includes duplicate_client_application.errors[:name], "has already been taken"
  end

  test "should be valid with duplicate name in different accounts" do
    Fabricate(:client_application, account: account, name: "Common Name")
    client_application_with_duplicate_name = Fabricate.build(:client_application, account: different_account, name: "Common Name")

    assert client_application_with_duplicate_name.valid?, "Client application should be valid with a duplicate name in a different account"
  end
end
