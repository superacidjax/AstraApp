require "test_helper"

class EventTest < ActiveSupport::TestCase
  setup do
    @event = events(:one)
  end

  test "should not save event without client application" do
    event = Event.new(
      name: "Signed in",
      client_user_id: "test-user",
      client_timestamp: Time.current
    )
    assert_not event.save, "Saved the event without a client_application"
    assert_includes event.errors[:client_application], "must exist", "Missing 'client_application must exist' error"
  end

  test "fixture event should be valid" do
    assert @event.valid?, "Fixture event is not valid"
  end

  test "should not save event without client timestamp" do
    event = Event.new(
      name: "Signed in",
      client_application: client_applications(:one),
      client_user_id: "test-user"
    )
    assert_not event.save, "Saved the event without a client timestamp"
    assert_includes event.errors[:client_timestamp], "can't be blank", "Missing 'client timestamp can't be blank' error"
  end

  test "should save event with valid attributes" do
    event = Event.new(
      client_application: client_applications(:one),
      name: "Signed in",
      client_timestamp: Time.current.iso8601,
      client_user_id: UUID7.generate
    )
    assert event.save, "Failed to save the event with valid attributes"
  end

  test "should have many properties through property_values" do
    assert_respond_to @event, :properties, "Event should have many properties through property_values"
  end

  test "should destroy associated property_values on event destruction" do
    event = events(:one)
    assert_difference "PropertyValue.count", -event.property_values.count do
      event.destroy
    end
  end

  test "should respond to account through client_application" do
    assert_respond_to @event, :account, "Event should respond to account through client_application"
    assert_equal @event.client_application.account, @event.account, "Event should return the correct account"
  end

  # New test scenario to validate the 'account' method behavior
  test "should return the correct account for the event" do
    client_application = client_applications(:one)
    event = Event.new(
      client_application: client_application,
      name: "Signed in",
      client_timestamp: Time.current.iso8601,
      client_user_id: UUID7.generate
    )

    assert_equal client_application.account, event.account, "Event should return the correct account through client_application"
  end
end
