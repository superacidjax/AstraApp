require "test_helper"

class EventTest < ActiveSupport::TestCase
  def event
    @event ||= Fabricate(:event)
  end

  def client_application
    @client_application ||= Fabricate(:client_application)
  end

  def property1
    @property1 ||= Fabricate(:property, event: event)
  end

  def property2
    @property2 ||= Fabricate(:property, event: event)
  end

  test "should not be valid without client application" do
    event = Fabricate.build(:event, client_application: nil)
    assert_not event.valid?, "Event should not be valid without a client_application"
    assert_includes event.errors[:client_application], "must exist"
  end

  test "should be valid with valid attributes" do
    event = Fabricate.build(:event)
    assert event.valid?, "Event should be valid with valid attributes"
  end

  test "should not be valid without client timestamp" do
    event = Fabricate.build(:event, client_timestamp: nil)
    assert_not event.valid?, "Event should not be valid without a client timestamp"
    assert_includes event.errors[:client_timestamp], "can't be blank"
  end

  test "should save event with valid attributes" do
    event = Fabricate.build(:event)
    assert event.save, "Failed to save the event with valid attributes"
  end

  test "should have many properties through property_values" do
    assert_respond_to event, :properties, "Event should have many properties through property_values"
  end

  test "should destroy associated properties on event destruction" do
    property1
    property2
    assert_difference "Property.count", -2 do
      event.destroy
    end
  end

  test "should respond to account through client_application" do
    assert_respond_to event, :account, "Event should respond to account through client_application"
    assert_equal event.client_application.account, event.account, "Event should return the correct account"
  end

  test "should return the correct account for the event" do
    event = Fabricate.build(:event)
    assert_equal event.client_application.account, event.account, "Event should return the correct account through client_application"
  end
end
