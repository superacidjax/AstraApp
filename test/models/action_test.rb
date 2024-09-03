require "test_helper"

class ActionTest < ActiveSupport::TestCase
  # Test presence validation for name
  test "should not save action without name" do
    action = ActionEmail.new
    assert_not action.save, "Saved the action without a name"
  end

  test "should save valid ActionEmail" do
    action = ActionEmail.new(name: "Test Email Action")
    action.account = accounts(:one)
    assert action.save, "Could not save a valid ActionEmail"
  end

  test "should save ActionNotify with destination" do
    action = ActionNotify.new(name: "Notify Action", data: {
      destination: "user@example.com" })
    action.account = accounts(:one)
    assert action.save, "Could not save a valid ActionNotify"
    assert_equal "user@example.com", action.destination
  end

  test "should save valid ActionConnect" do
    action = ActionConnect.new(name: "Connect Action", data: {
      integration_id: "f47ac10b-58cc-4372-a567-0e02b2c3d479",
      integration_name: "Integration One" })
    action.account = accounts(:one)
    assert action.save, "Could not save a valid ActionConnect"
  end
end
