require "test_helper"

class ClientApplicationPersonTest < ActiveSupport::TestCase
  setup do
    @client_application_one = client_applications(:one)
    @client_application_two = client_applications(:two)
    @person_one = people(:one)
    @person_two = people(:two)
  end

  test "should allow the same person to belong to multiple client_applications" do
    client_application_person_one = ClientApplicationPerson.new(
      client_application: @client_application_one, person: @person_one
    )
client_application_person_two = ClientApplicationPerson.new(
      client_application: @client_application_two, person: @person_two
    )

    assert client_application_person_one.save,
      "Could not save ClientApplicationUser for Brian and ClientApplication One"
    assert client_application_person_two.save,
      "Could not save Client ApplicationUser for Brian and ClientApplication Two"
  end

  test "should verify person associations through client_applications" do
    # Verify Person One's associations
    @person_one.client_applications << @client_application_one
    @person_one.client_applications << @client_application_two
    person_one_client_applications = @person_one.client_applications
    assert_includes person_one_client_applications, @client_application_one, "Brian is not associated with ClientApplication One"
    assert_includes person_one_client_applications, @client_application_two, "Brian is not associated with Client Application Two"

    # Verify Michael's associations
    @person_two.client_applications << @client_application_one
    person_two_client_applications = @person_two.client_applications
    assert_includes person_two_client_applications, @client_application_one, "Michael is not associated with ClientApplication One"
    assert_includes person_two_client_applications, @client_application_two, "Michael is not be associated with Client Application Two"
  end
end
