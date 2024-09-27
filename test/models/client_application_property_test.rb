require "test_helper"

class ClientApplicationPropertyTest < ActiveSupport::TestCase
  setup do
    @client_application = client_applications(:one)
    @property = properties(:one)
    @client_application_property = ClientApplicationProperty.new(property: @property, client_application: @client_application)
  end

  test "fixture client_application_property should be valid" do
    assert @client_application_property.valid?, "Fixture client_application_property is not valid"
  end

  test "should not save without a property" do
    client_application_property = ClientApplicationProperty.new(client_application: @client_application)
    assert_not client_application_property.save, "Saved the client_application_property without a property"
    assert client_application_property.errors[:property].any?, "There should be an error for missing property"
  end

  test "should not save without a client_application" do
    client_application_property = ClientApplicationProperty.new(property: @property)
    assert_not client_application_property.save, "Saved the client_application_property without a client_application"
    assert client_application_property.errors[:client_application].any?, "There should be an error for missing client_application"
  end

  test "should save valid client_application_property" do
    client_application_property = ClientApplicationProperty.new(property: @property, client_application: @client_application)
    assert client_application_property.save, "Failed to save a valid client_application_property"
  end
end
