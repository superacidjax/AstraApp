require "test_helper"
require "webmock/minitest"

class EventTest < ActiveSupport::TestCase
  # Setup mock response
  def setup
    @event_attributes = {
      event_name: "User Sign Up",
      datetime: "2024-09-03T12:34:56Z",
      client_application_id: "f47ac10b-58cc-4372-a567-0e02b2c3d479"
    }

    # Stub the API request
    stub_request(:get, "http://localhost:4000/events/1.json")
      .to_return(
        body: @event_attributes.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end

  # Test fetching an event by ID
  test "should fetch event from API" do
    event = Event.find(1)
    assert_equal "User Sign Up", event.event_name
    assert_equal Time.parse("2024-09-03T12:34:56Z"), event.datetime
    assert_equal "f47ac10b-58cc-4372-a567-0e02b2c3d479", event.client_application_id
  end

  # Test default site URL
  test "should use default site URL if environment variable is not set" do
    assert_equal "http://localhost:4000", Event.site.to_s
  end

  # Test site URL from environment variable
  test "should use site URL from environment variable if set" do
    original_site = Event.site

    ENV["EVENTS_API_URL"] = "http://api.example.com"
    Event.site = ENV.fetch("EVENTS_API_URL", "http://localhost:4000")

    assert_equal "http://api.example.com", Event.site.to_s

    # Reset site to original value
    Event.site = original_site
    ENV.delete("EVENTS_API_URL")
  end
end
