require "test_helper"
require "webmock/minitest"

class FlowRecipientTest < ActiveSupport::TestCase
  def flow
    @flow ||= Fabricate(:flow)
  end

  def flow_action
    @flow_action ||= Fabricate(:flow_action)
  end

  def person
    @person ||= Fabricate(:person)
  end

  test "should not save flow recipient without person_id" do
    flow_recipient = Fabricate.build(:flow_recipient, flow: flow, person_id: nil)
    assert_not flow_recipient.save, "Saved the flow recipient without a person_id"
  end

  test "should save flow recipient with valid attributes" do
    flow_recipient = Fabricate.build(:flow_recipient, flow: flow, person: person)
    assert flow_recipient.save, "Could not save a valid flow recipient"
  end

  test "should fetch associated person from API" do
    flow_recipient = Fabricate(:flow_recipient, flow: flow, person: person)
    assert_not_nil flow_recipient.person, "Associated person should not be nil"
  end

  test "should have default status as active" do
    flow_recipient = Fabricate.build(:flow_recipient, flow: flow, person: person)
    assert_equal "active", flow_recipient.status, "Default status is not 'active'"
  end

  test "should set and get status correctly" do
    flow_recipient = Fabricate.build(:flow_recipient, flow: flow, person: person)

    flow_recipient.status = :paused
    assert_equal "paused", flow_recipient.status, "Status was not set to 'paused'"

    flow_recipient.status = :complete
    assert_equal "complete", flow_recipient.status, "Status was not set to 'complete'"
  end

  test "should not save flow recipient without is_goal_achieved" do
    flow_recipient = Fabricate.build(:flow_recipient, flow: flow, person: person, is_goal_achieved: nil)
    assert_not flow_recipient.save, "Saved the flow recipient without is_goal_achieved"
  end

  test "should allow association with last completed flow action" do
    flow_recipient = Fabricate.build(:flow_recipient, flow: flow, person: person, last_completed_flow_action: flow_action)
    assert flow_recipient.save, "Could not save flow recipient with last completed flow action"
    assert_equal flow_action, flow_recipient.last_completed_flow_action, "Last completed flow action was not set correctly"
  end
end
