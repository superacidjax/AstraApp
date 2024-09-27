require "test_helper"

class ClientApplicationEventTest < ActiveSupport::TestCase
  setup do
    @client_application_event = client_application_events(:one)
  end

  test "fixture client_application_event should be valid" do
    assert @client_application_event.valid?, "Fixture client_application_event is not valid"
  end

  test "should not save client_application_event without a client_application" do
    client_application_event = ClientApplicationEvent.new(event: events(:one))
    assert_not client_application_event.save, "Saved the client_application_event without a client_application"
    assert client_application_event.errors[:client_application].any?, "There should be an error for missing client_application"
  end

  test "should not save client_application_event without an event" do
    client_application_event = ClientApplicationEvent.new(client_application: client_applications(:one))
    assert_not client_application_event.save, "Saved the client_application_event without an event"
    assert client_application_event.errors[:event].any?, "There should be an error for missing event"
  end

  test "should save valid client_application_event" do
    client_application_event = ClientApplicationEvent.new(client_application: client_applications(:one), event: events(:one))
    assert client_application_event.save, "Failed to save a valid client_application_event"
  end
end
