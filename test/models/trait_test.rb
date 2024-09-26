require "test_helper"

class TraitTest < ActiveSupport::TestCase
  setup do
    @trait = traits(:one) # Assuming you have a fixture named :one for traits
  end

  test "fixture trait should be valid" do
    assert @trait.valid?, "Fixture trait is not valid"
  end

  test "should not save trait without a name" do
    trait = Trait.new(is_active: true, account: accounts(:one), client_application: client_applications(:one))
    assert_not trait.save, "Saved the trait without a name"
  end

  test "should not save trait without is_active" do
    trait = Trait.new(name: "Test Trait", account: accounts(:one), client_application: client_applications(:one))
    trait.is_active = nil
    assert_not trait.save, "Saved the trait without an is_active value"
    assert trait.errors[:is_active].any?, "There should be an error for the is_active"
  end

  test "should not save trait without account" do
    trait = Trait.new(name: "Test Trait", is_active: true, client_application: client_applications(:one))
    assert_not trait.save, "Saved the trait without an account"
    assert trait.errors[:account].any?, "There should be an error for the account"
  end

  test "should not save trait without client_application" do
    trait = Trait.new(name: "Test Trait", is_active: true, account: accounts(:one))
    assert_not trait.save, "Saved the trait without a client_application"
    assert trait.errors[:client_application].any?, "There should be an error for the client_application"
  end
end
