require "test_helper"

class ClientApplicationPersonTest < ActiveSupport::TestCase
  def client_application_one
    @client_application_one ||= Fabricate(:client_application)
  end

  def client_application_two
    @client_application_two ||= Fabricate(:client_application)
  end

  def person_one
    @person_one ||= Fabricate(:person)
  end

  def person_two
    @person_two ||= Fabricate(:person)
  end

  test "should allow the same person to belong to multiple client_applications" do
    client_application_person_one = Fabricate.build(:client_application_person,
                                                    client_application: client_application_one, person: person_one)
    client_application_person_two = Fabricate.build(:client_application_person,
                                                    client_application: client_application_two, person: person_one)

    assert client_application_person_one.save,
      "Could not save ClientApplicationPerson for person_one and client_application_one"
    assert client_application_person_two.save,
      "Could not save ClientApplicationPerson for person_one and client_application_two"
  end

  test "should verify person associations through client_applications" do
    person_one.client_applications << client_application_one
    person_one.client_applications << client_application_two
    person_one_client_applications = person_one.client_applications
    assert_includes person_one_client_applications, client_application_one,
      "Person one is not associated with client_application_one"
    assert_includes person_one_client_applications, client_application_two,
      "Person one is not associated with client_application_two"

    person_two.client_applications << client_application_one
    person_two_client_applications = person_two.client_applications
    assert_includes person_two_client_applications, client_application_one,
      "Person two is not associated with client_application_one"
    assert_not_includes person_two_client_applications, client_application_two,
      "Person two should not be associated with client_application_two"
  end
end
