require "test_helper"

class ActionComponentTest < ViewComponent::TestCase
  setup do
    @account = Fabricate(:account)
    @action_sms = Fabricate(:action_sms, account: @account, name: "My SMS Action")
  end

  test "renders known action type" do
    render_inline(ActionComponent.new(action_record: @action_sms))

    assert_selector ".box" do
      assert_text "My SMS Action"
      assert_text "SMS"
    end
  end
end
