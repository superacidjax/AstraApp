require "application_system_test_case"

class FlowCreationTest < ApplicationSystemTestCase
  setup do
    @account = Fabricate(:account)
    @user = Fabricate(:user)
    Fabricate(:account_user, account: @account, user: @user)
    @goal = Fabricate(:goal_with_rules, account: @account, name: "Weight Loss Goal")
    @sms_action = Fabricate(:action_sms, account: @account, name: "Appointment Reminder")
  end

  test "user creates a new flow with a goal and SMS action" do
    visit new_flow_path
    fill_in "Name", with: "Health Improvement Flow"
    find("select[name*='[goal_id]']", visible: :all).select("Weight Loss Goal")
    find("select[name*='[action_id]']", visible: :all).select("Appointment Reminder")
    fill_in "SMS Content", with: "Don't forget your appointment tomorrow!"
    click_button "Save Flow"

    assert_selector "h1", text: "Health Improvement Flow"
    assert_text "Flow was successfully created."
    assert_text "Weight Loss Goal"
    assert_text "Appointment Reminder"
  end
end
