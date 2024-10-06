require "test_helper"

class ClientApplicationTraitTest < ActiveSupport::TestCase
  setup do
    @client_application = Fabricate(:client_application)
    @trait = Fabricate(:trait)
    @client_application_trait = Fabricate.build(
      :client_application_trait,
      trait: @trait,
      client_application: @client_application
    )
  end

  test "fabricated client_application_trait should be valid" do
    assert @client_application_trait.valid?,
      "Fabricated client_application_trait is not valid"
  end

  test "should not save without a trait" do
    client_application_trait = Fabricate.build(
      :client_application_trait,
      trait: nil,
      client_application: @client_application
    )
    assert_not client_application_trait.save,
      "Saved the client_application_trait without a trait"
    assert client_application_trait.errors[:trait].any?,
      "There should be an error for missing trait"
  end

  test "should not save without a client_application" do
    client_application_trait = Fabricate.build(
      :client_application_trait,
      trait: @trait,
      client_application: nil
    )
    assert_not client_application_trait.save,
      "Saved the client_application_trait without a client_application"
    assert client_application_trait.errors[:client_application].any?,
      "There should be an error for missing client_application"
  end

  test "should save valid client_application_trait" do
    client_application_trait = Fabricate.build(
      :client_application_trait,
      trait: @trait,
      client_application: @client_application
    )
    assert client_application_trait.save,
      "Failed to save a valid client_application_trait"
  end
end
