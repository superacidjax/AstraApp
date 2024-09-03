require "test_helper"
require "webmock/minitest"

class PersonTest < ActiveSupport::TestCase
  # Setup mock response
  def setup
    @person_attributes = {
      email_address: "john.doe@example.com",
      datetime: "2024-09-03T12:34:56Z",
      sms_number: "+14085551212",
      first_name: "John",
      last_name: "Doe",
      client_application_id: "f47ac10b-58cc-4372-a567-0e02b2c3d479",
      id: "47ac10b-58cc-4372-a567-0e02b2c3d478"
    }

    # Stub the API request
    stub_request(:get, "http://localhost:4000/people/1.json")
      .to_return(
        body: @person_attributes.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end

  # Test fetching a person by ID
  test "should fetch person from API" do
    person = Person.find(1)
    assert_equal "john.doe@example.com", person.email_address
    assert_equal Time.parse("2024-09-03T12:34:56Z"), person.datetime
    assert_equal "+14085551212", person.sms_number
    assert_equal "John", person.first_name
    assert_equal "Doe", person.last_name
    assert_equal "f47ac10b-58cc-4372-a567-0e02b2c3d479", person.client_application_id
    assert_equal "47ac10b-58cc-4372-a567-0e02b2c3d478", person.id
  end

  # Test default site URL
  test "should use default site URL if environment variable is not set" do
    assert_equal "http://localhost:4000", Person.site.to_s
  end

  # Test site URL from environment variable
  test "should use site URL from environment variable if set" do
    original_site = Person.site

    ENV["PERSONS_API_URL"] = "http://api.example.com"
    Person.site = ENV.fetch("PERSONS_API_URL", "http://localhost:4000")

    assert_equal "http://api.example.com", Person.site.to_s

    # Reset site to original value
    Person.site = original_site
    ENV.delete("PERSONS_API_URL")
  end
end
