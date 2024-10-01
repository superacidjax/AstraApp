require "test_helper"

class EventProcessorTest < ActiveSupport::TestCase
  setup do
    @event_data = {
      client_user_id: "0191faa2-b4d7-78bc-8cdc-6a4dc176ebb4",
      name: "New sign up",
      properties: {
        "subscription_type" => "premium",
        "subscription_value" => "930"
      },
      client_timestamp: "2023-10-25T23:48:46+00:00",
      application_id: client_applications(:one).id
    }
  end

  test "should create an event with valid data" do
    assert_difference "Event.count", +1 do
      assert_difference "Property.count", +2 do
        assert_difference "PropertyValue.count", +2 do
          EventProcessor.call(@event_data)
        end
      end
    end

    event = Event.find_by(client_user_id: @event_data[:client_user_id])
    assert_not_nil event, "Event should be created"
    assert_equal event.client_timestamp, @event_data[:client_timestamp].to_time, "Timestamp should match"
    assert_equal event.client_application.account_id, ClientApplication.find(@event_data[:application_id]).account_id, "Account should match"

    properties = event.properties.map(&:name)
    assert_includes properties, "subscription_type", "Event should have subscription_type property"
    assert_includes properties, "subscription_value", "Event should have subscription_value property"
  end

  test "should raise an error if client_user_id is missing" do
    invalid_event_data = @event_data.except(:client_user_id)

    assert_raises(ArgumentError, "Missing required parameters: client_user_id") do
      EventProcessor.call(invalid_event_data)
    end
  end

  test "should infer correct types for properties" do
    property_data = {
      "numeric_property" => "1234",
      "boolean_property" => "true",
      "text_property" => "random text",
      "datetime_property" => "2024-09-25T08:28:24Z"
    }
    @event_data[:properties] = property_data

    EventProcessor.call(@event_data)

    event = Event.find_by(client_user_id: @event_data[:client_user_id])
    assert_not_nil event, "Event should be created"

    property_types = event.properties.map(&:value_type)
    assert_includes property_types, "numeric", "Property should have numeric value type"
    assert_includes property_types, "boolean", "Property should have boolean value type"
    assert_includes property_types, "text", "Property should have text value type"
    assert_includes property_types, "datetime", "Property should have datetime value type"
  end

  test "should not create event if application_id is missing" do
    invalid_event_data = @event_data.except(:application_id)

    assert_raises(ArgumentError, "Missing required parameters: application_id") do
      EventProcessor.call(invalid_event_data)
    end
  end

  test "should raise error when properties are missing" do
    invalid_event_data = @event_data.except(:properties)

    assert_raises(ArgumentError, "Missing required parameters: properties") do
      EventProcessor.call(invalid_event_data)
    end
  end
end
