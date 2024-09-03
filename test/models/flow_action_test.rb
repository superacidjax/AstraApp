require "test_helper"

class FlowActionTest < ActiveSupport::TestCase
  test "should save FlowActionEmail with template_id and deliver_at" do
    template_id = UUID7.generate
    flow_action = FlowActionEmail.new(flow: flows(:one), action:
                                      actions(:action_email), flow_data: {
                                        template_id: template_id,
                                        deliver_at: "2024-09-01 12:00:00" })
    assert flow_action.save, "Could not save a valid FlowActionEmail"
    assert_equal template_id, flow_action.template_id
  end

  test "should save FlowActionSms with template_id" do
    template_id = UUID7.generate
    flow_action = FlowActionSms.new(flow: flows(:one),
                                    action: actions(:action_sms), flow_data: {
                                      template_id: template_id })
    assert flow_action.save, "Could not save a valid FlowActionSms"
  end

  test "should save FlowActionWait with wait_in_seconds" do
    flow_action = FlowActionWait.new(flow: flows(:one), action:
                                     actions(:action_wait), flow_data: {
                                       wait_in_seconds: 3600 })
    assert flow_action.save, "Could not save a valid FlowActionWait"
    assert_equal 3600, flow_action.wait_in_seconds
  end

  test "should save FlowActionNotify with destination" do
    flow_action = FlowActionNotify.new(flow: flows(:one), action:
                                       actions(:action_notify), flow_data: {
                                         destination: "user@example.com" })
    assert flow_action.save, "Could not save a valid FlowActionNotify"
    assert_equal "user@example.com", flow_action.destination
  end

  test "should save FlowActionConnect with data_to_send" do
    flow_action = FlowActionConnect.new(flow: flows(:one), action:
                                        actions(:action_connect), flow_data: {
                                          data_to_send: "Some data" })
    assert flow_action.save, "Could not save a valid FlowActionConnect"
    assert_equal "Some data", flow_action.data_to_send
  end
end
