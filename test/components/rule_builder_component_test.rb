require "test_helper"

class RuleBuilderComponentTest < ViewComponent::TestCase
  setup do
    @account = Fabricate(:account)
    prepare_test_goal(@account, "PersonRule")
  end

  test "renders the rule builder interface for a PersonRule" do
    render_inline(RuleBuilderComponent.new(
      form: @goal_rule_form,
      current_account: @account,
      traits: @traits
    ))

    assert_selector "select.input[data-action='change->people-rule-builder#updateOperator'][data-people-rule-builder-target='traitSelector']"
    assert_selector "select.input[data-people-rule-builder-target='operatorSelector']"
    assert_selector "input.rule-type-field[value='PersonRule']", visible: :all
  end
end
