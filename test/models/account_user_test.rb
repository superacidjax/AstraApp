require "test_helper"

class AccountUserTest < ActiveSupport::TestCase
  setup do
    @account_one = Fabricate(:account)
    @account_two = Fabricate(:account)
    @brian = Fabricate(:user)
    @michael = Fabricate(:user)
  end

  test "should allow the same user to belong to multiple accounts" do
    account_user_one = Fabricate.build(:account_user, account: @account_one, user: @brian)
    account_user_two = Fabricate.build(:account_user, account: @account_two, user: @brian)

    assert account_user_one.save, "Could not save AccountUser for Brian and Account One"
    assert account_user_two.save, "Could not save AccountUser for Brian and Account Two"
  end

  test "should verify user associations through account" do
    @brian.accounts << @account_one
    @brian.accounts << @account_two
    brian_accounts = @brian.accounts
    assert_includes brian_accounts, @account_one, "Brian is not associated with Account One"
    assert_includes brian_accounts, @account_two, "Brian is not associated with Account Two"

    @michael.accounts << @account_one
    michael_accounts = @michael.accounts
    assert_includes michael_accounts, @account_one, "Michael is not associated with Account One"
    assert_not_includes michael_accounts, @account_two, "Michael should not be associated with Account Two"
  end
end
