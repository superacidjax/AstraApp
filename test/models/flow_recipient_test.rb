require "test_helper"
require "webmock/minitest"

class FlowRecipientTest < ActiveSupport::TestCase
  setup do
    @flow = flows(:one) # Assuming you have a fixture named `one` for the Flow model
    @person_id = "f47ac10b-58cc-4372-a567-0e02b2c3d479" # Sample UUID for a person
    @flow_action = flow_actions(:flow_action_email)

    # Mock API response for Person
    @person_attributes = {
      id: @person_id,
      email_address: "john.doe@example.com",
      datetime: "2024-09-03T12:34:56Z",
      sms_number: "+14085551212",
      first_name: "John",
      last_name: "Doe",
      client_application_id: "f47ac10b-58cc-4372-a567-0e02b2c3d479"
    }

    stub_request(:get, "http://localhost:4000/people/#{@person_id}.json")
      .to_return(
        body: @person_attributes.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end

  # Test presence validation for person_id
  test "should not save flow recipient without person_id" do
    flow_recipient = FlowRecipient.new(flow: @flow, status: :active, is_goal_achieved: false)
    assert_not flow_recipient.save, "Saved the flow recipient without a person_id"
  end

  # Test UUID format validation for person_id
  test "should not save flow recipient with invalid person_id format" do
    flow_recipient = FlowRecipient.new(flow: @flow, person_id: "invalid-uuid", status: :active, is_goal_achieved: false)
    assert_not flow_recipient.save, "Saved the flow recipient with an invalid person_id"
  end

  # Test saving a valid FlowRecipient
  test "should save flow recipient with valid attributes" do
    flow_recipient = FlowRecipient.new(flow: @flow, person_id: @person_id, status: :active, is_goal_achieved: false)
    assert flow_recipient.save, "Could not save a valid flow recipient"
  end

  # Test fetching the associated Person
  test "should fetch associated person from API" do
    flow_recipient = FlowRecipient.create!(flow: @flow, person_id: @person_id, status: :active, is_goal_achieved: false)
    person = flow_recipient.person

    assert_not_nil person, "Associated person should not be nil"
    assert_equal "john.doe@example.com", person.email_address
    assert_equal "John", person.first_name
    assert_equal "Doe", person.last_name
  end

  # Test default status value
  test "should have default status as active" do
    flow_recipient = FlowRecipient.new(flow: @flow, person_id: @person_id, is_goal_achieved: false)
    assert_equal "active", flow_recipient.status, "Default status is not 'active'"
  end

  # Test setting and getting status values
  test "should set and get status correctly" do
    flow_recipient = FlowRecipient.new(flow: @flow, person_id: @person_id, is_goal_achieved: false)

    flow_recipient.status = :paused
    assert_equal "paused", flow_recipient.status, "Status was not set to 'paused'"

    flow_recipient.status = :complete
    assert_equal "complete", flow_recipient.status, "Status was not set to 'complete'"
  end

  # Test presence validation for is_goal_achieved
  test "should not save flow recipient without is_goal_achieved" do
    flow_recipient = FlowRecipient.new(flow: @flow, person_id: @person_id, status: :active, is_goal_achieved: nil)
    assert_not flow_recipient.save, "Saved the flow recipient without is_goal_achieved"
  end

  # Test relationship with last completed FlowAction
  test "should allow association with last completed flow action" do
    flow_recipient = FlowRecipient.new(flow: @flow, person_id: @person_id, status: :active, is_goal_achieved: false, last_completed_flow_action: @flow_action)
    assert flow_recipient.save, "Could not save flow recipient with last completed flow action"
    assert_equal @flow_action, flow_recipient.last_completed_flow_action, "Last completed flow action was not set correctly"
  end
end
