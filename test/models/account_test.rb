require "test_helper"

class AccountTest < ActiveSupport::TestCase
  setup do
    @account = accounts(:one)
  end

  test "should not save account without name" do
    account = Account.new
    assert_not account.save, "Saved the account without a name"
  end

  test "fixture account should be valid" do
    assert @account.valid?, "Fixture account is not valid"
  end

  test "should have validation error on name" do
    account = Account.new
    assert account.invalid?, "Account without a name should be invalid"
    assert account.errors[:name].any?, "There should be an error for the name"
  end
end
