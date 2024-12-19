require "test_helper"

class ActionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = Fabricate(:account)
    @action_sms = Fabricate(:action_sms, account: @account, name: "My SMS Action")
    @action_wait = Fabricate(:action_wait, account: @account, name: "My Wait Action")
  end

  test "should get index" do
    get actions_url
    assert_response :success
    assert_select "h1", "Actions"
    assert_select "p", text: "My SMS Action"
    assert_select "p", text: "My Wait Action"
  end

  test "should show action" do
    get action_url(@action_sms)
    assert_response :success
    assert_select "p", @action_sms.name
    assert_select "p", "SMS"
  end

  test "should get new" do
    get new_action_url
    assert_response :success
    assert_select "form[action='#{actions_path}']"
  end

  test "should create action with valid data" do
    assert_difference("Action.count", 1) do
      post actions_url, params: {
        action_record: {
          name: "New Email Action",
          type: "ActionEmail"
        }
      }
    end

    assert_redirected_to action_path(Action.last)
    follow_redirect!
    assert_select "p", "New Email Action"
    assert_select ".notification.is-success",  "Action was successfully created."
  end

  test "should not create action with invalid data" do
    # Missing name
    assert_no_difference("Action.count") do
      post actions_url, params: {
        action_record: {
          name: "",
          type: "ActionPost"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select "form[action='#{actions_path}']"
    assert_select ".notification.is-danger", "There were errors creating the action."
  end

  test "should get edit" do
    get edit_action_url(@action_sms)
    assert_response :success
    assert_select "form[action='#{action_path(@action_sms)}']"
  end

  test "should update action with valid data" do
    patch action_url(@action_sms), params: {
      action_record: {
        name: "Updated SMS Action",
        type: "ActionSms"
      }
    }

    assert_redirected_to action_path(@action_sms)
    follow_redirect!
    assert_select "p", "Updated SMS Action"
    assert_select ".notification.is-success",  "Action was successfully updated."
  end

  test "should not update action with invalid data" do
    patch action_url(@action_sms), params: {
      action_record: {
        name: "",
        type: "ActionSms"
      }
    }

    assert_response :unprocessable_entity
    assert_select "form[action='#{action_path(@action_sms)}']"
    assert_select ".notification.is-danger", "There were errors updating the action."
  end

  test "should destroy action" do
    assert_difference("Action.count", -1) do
      delete action_url(@action_wait)
    end

    assert_redirected_to actions_path
    follow_redirect!
    assert_select ".notification.is-success",  "Action was successfully destroyed."
  end
end
