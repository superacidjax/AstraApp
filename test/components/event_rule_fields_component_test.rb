require "test_helper"

class EventRuleFieldsComponentTest < ViewComponent::TestCase
  setup do
    @account = Fabricate(:account)
    prepare_test_goal(@account, "EventRule")
  end

  test "renders the event rule fields" do
    render_inline(EventRuleFieldsComponent.new(form: @rule_form))
    assert_selector "input.rule-type-field[value='EventRule']", visible: :all
    assert_selector "select.form-select[name='goal[goal_rules_attributes][0][rule_attributes][occurrence_operator]']", visible: :all
    assert_selector "select[data-event-rule-builder-target='eventSelector']", visible: :all
  end
end
