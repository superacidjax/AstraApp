require "test_helper"

class ActionTest < ActiveSupport::TestCase
  test "should not save action without name" do
    skip
    action = Fabricate.build(:action_email, name: nil)
    assert_not action.save, "Saved the action without a name"
  end

  test "should save valid ActionEmail" do
    skip
    action = Fabricate.build(:action_email, name: "Test Email Action")
    assert action.save, "Could not save a valid ActionEmail"
  end

  test "should save ActionNotify with destination" do
    skip
    action = Fabricate.build(:action_notify, data: {
      destination: "user@example.com" })
    assert action.save, "Could not save a valid ActionNotify"
    assert_equal "user@example.com", action.destination
  end

  test "should save valid ActionConnect" do
    skip
    action = Fabricate.build(:action_connect, data: {
      integration_id: "f47ac10b-58cc-4372-a567-0e02b2c3d479",
      integration_name: "Integration One" })
    assert action.save, "Could not save a valid ActionConnect"
  end
end
