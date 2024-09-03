require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @valid_email = "valid.email@example.com"
    @invalid_emails = [
      "invalid_email",           # No domain
      "invalid@.com",            # No domain name
      "invalid@com",             # No top-level domain
      "invalid@com.",            # Trailing dot in email address
      "@no-local-part.com",      # No local part
      "no-at-sign.com"           # No '@' sign
    ]
  end

  test "should not save user without email" do
    user = User.new
    assert_not user.save, "Saved the user without an email"
  end

  test "should save user with valid email" do
    user = User.new(email: @valid_email)
    assert user.valid?, "User with a valid email should be valid"
    assert user.save, "User with a valid email should be saved"
  end

  test "should not save user with invalid email" do
    @invalid_emails.each do |invalid_email|
      user = User.new(email: invalid_email)
      assert_not user.valid?, "#{invalid_email.inspect} should be invalid"
      assert user.errors[:email].any?, "User with invalid email #{invalid_email.inspect} should have errors"
      assert_not user.save, "User with invalid email #{invalid_email.inspect} should not be saved"
    end
  end

  test "fixture user should be valid" do
    assert @user.valid?, "Fixture user is not valid"
  end

  test "should have validation error on email when email is missing" do
    user = User.new
    assert user.invalid?, "User without an email should be invalid"
    assert user.errors[:email].any?, "There should be an error for the email"
  end

  test "should not save user with duplicate email" do
    duplicate_user = User.new(email: @user.email) # Using the email from the fixture user
    assert_not duplicate_user.save, "Saved the user with a duplicate email"
  end

  test "should have validation error on email when email is not unique" do
    duplicate_user = User.new(email: @user.email)
    assert duplicate_user.invalid?, "User with duplicate email should be invalid"
    assert duplicate_user.errors[:email].any?, "There should be an error for duplicate email"
  end
end
