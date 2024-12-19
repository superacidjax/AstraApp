require "test_helper"

class ActionFormComponentTest < ViewComponent::TestCase
  include Rails.application.routes.url_helpers

  setup do
    @account = Fabricate(:account)
    @action_record = @account.actions.new
    @url = actions_path
    @method = :post
    @action_types = [
      [ "SMS", "ActionSms" ],
      [ "Wait", "ActionWait" ],
      [ "Snail Mail", "ActionPost" ],
      [ "Email", "ActionEmail" ],
      [ "Internal Notifier", "ActionNotify" ],
      [ "API", "ActionConnect" ]
    ]
  end

  test "renders a form with name and action type fields" do
    render_inline(ActionFormComponent.new(
      action_record: @action_record,
      url: @url,
      method: @method,
      action_types: @action_types
    ))

    assert_selector "form[action='#{@url}'][method='post']"
    assert_selector "label.label[for='action_record_name']", text: "Name"
    assert_selector "input.input[name='action_record[name]'][type='text']"

    assert_selector "label.label[for='action_record_type']", text: "Action Type"
    assert_selector "select[name='action_record[type]']" do
      assert_selector "option", text: "Select an action type"
      assert_selector "option", text: "SMS"
      assert_selector "option", text: "Wait"
      assert_selector "option", text: "Snail Mail"
      assert_selector "option", text: "Email"
      assert_selector "option", text: "Internal Notifier"
      assert_selector "option", text: "API"
    end

    assert_selector "input[type='submit'][value='Save Action']"
  end

  test "populates name field if action_record has a name" do
    @action_record.name = "Test Action"
    render_inline(ActionFormComponent.new(
      action_record: @action_record,
      url: @url,
      method: @method,
      action_types: @action_types
    ))

    assert_selector "input[name='action_record[name]'][value='Test Action']"
  end

  test "selects the current type if action_record has a type" do
    @action_record.type = "ActionEmail"
    render_inline(ActionFormComponent.new(
      action_record: @action_record,
      url: @url,
      method: @method,
      action_types: @action_types
    ))

    assert_selector "select[name='action_record[type]'] option[selected]", text: "Email"
  end
end
