require "test_helper"

class AccountUserTest < ActiveSupport::TestCase
  setup do
    @account_one = accounts(:one)
    @account_two = accounts(:two)
    @brian = users(:one)
    @michael = users(:two)
  end

  test "should allow the same user to belong to multiple accounts" do
    # Check that Brian is associated with both Account One and Account Two
    account_user_one = AccountUser.new(account: @account_one, user: @brian)
    account_user_two = AccountUser.new(account: @account_two, user: @brian)

    assert account_user_one.save, "Could not save AccountUser for Brian and Account One"
    assert account_user_two.save, "Could not save AccountUser for Brian and Account Two"
  end

  test "should verify user associations through account" do
    # Verify Brian's associations
    @brian.accounts << @account_one
    @brian.accounts << @account_two
    brian_accounts = @brian.accounts
    assert_includes brian_accounts, @account_one, "Brian is not associated with Account One"
    assert_includes brian_accounts, @account_two, "Brian is not associated with Account Two"

    # Verify Michael's associations
    @michael.accounts << @account_one
    michael_accounts = @michael.accounts
    assert_includes michael_accounts, @account_one, "Michael is not associated with Account One"
    assert_includes michael_accounts, @account_two, "Michael is not be associated with Account Two"
  end
end
