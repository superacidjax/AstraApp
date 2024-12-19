require "test_helper"

class FlowActionTest < ActiveSupport::TestCase
  setup do
    @flow = Fabricate(:flow)
    @action_email = Fabricate.build(:flow_action_email)
    @action_sms = Fabricate.build(:flow_action_sms)
    @action_wait = Fabricate.build(:flow_action_wait)
    @action_notify = Fabricate.build(:flow_action_notify)
    @action_connect = Fabricate.build(:flow_action_connect)
  end

  test "should save FlowActionEmail with template_id and deliver_at" do
    skip
    template_id = UUID7.generate
    flow_action = Fabricate.build(:flow_action_email, flow: @flow, data: {
      template_id: template_id,
      deliver_at: "2024-09-01 12:00:00"
    })

    assert flow_action.save, "Could not save a valid FlowActionEmail"
    assert_equal template_id, flow_action.template_id
  end

  test "should save FlowActionSms with template_id" do
    skip
    template_id = UUID7.generate
    flow_action = Fabricate.build(:flow_action_sms, flow: @flow, data: {
      template_id: template_id
    })

    assert flow_action.save, "Could not save a valid FlowActionSms"
  end

  test "should save FlowActionWait with wait_in_seconds" do
    skip
    flow_action = Fabricate.build(:flow_action_wait, flow: @flow, data: {
      wait_in_seconds: 3600
    })

    assert flow_action.save, "Could not save a valid FlowActionWait"
    assert_equal 3600, flow_action.wait_in_seconds
  end

  test "should save FlowActionNotify with destination" do
    skip
    flow_action = Fabricate.build(:flow_action_notify, flow: @flow, data: {
      destination: "user@example.com"
    })

    assert flow_action.save, "Could not save a valid FlowActionNotify"
    assert_equal "user@example.com", flow_action.destination
  end

  test "should save FlowActionConnect with data_to_send" do
    skip
    flow_action = Fabricate.build(:flow_action_connect, flow: @flow, data: {
      data_to_send: "Some data"
    })

    assert flow_action.save, "Could not save a valid FlowActionConnect"
    assert_equal "Some data", flow_action.data_to_send
  end
end
