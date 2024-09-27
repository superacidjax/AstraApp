require "test_helper"

class EventTest < ActiveSupport::TestCase
  setup do
    @event = events(:one)
  end

  test "should not save event without account" do
    event = Event.new
    assert_not event.save, "Saved the event without an account"
  end

  test "fixture event should be valid" do
    assert @event.valid?, "Fixture event is not valid"
  end

  test "should have validation error on account" do
    event = Event.new
    assert event.invalid?, "Event without an account should be invalid"
    assert_includes event.errors[:account], "must exist", "Missing 'account must exist' error"
  end

  test "should not save event without client timestamp" do
    event = Event.new(account: accounts(:one))
    assert_not event.save, "Saved the event without a client timestamp"
    assert_includes event.errors[:client_timestamp], "can't be blank", "Missing 'client timestamp can't be blank' error"
  end

  test "should save event with valid attributes" do
    event = Event.new(
      account: accounts(:one),
      name: "Signed in",
      client_timestamp: Time.current.iso8601,
      client_user_id: UUID7.generate
    )
    assert event.save, "Failed to save the event with valid attributes"
  end

  test "should have many client_applications through client_application_events" do
    assert_respond_to @event, :client_applications, "Event should have many client_applications"
  end

  test "should have many properties through property_values" do
    assert_respond_to @event, :properties, "Event should have many properties"
  end

  test "should destroy associated client_application_events on event destruction" do
    event = events(:one)
    assert_difference "ClientApplicationEvent.count", -event.client_application_events.count do
      event.destroy
    end
  end

  test "should destroy associated property_values on event destruction" do
    event = events(:one)
    assert_difference "PropertyValue.count", -event.property_values.count do
      event.destroy
    end
  end
end
