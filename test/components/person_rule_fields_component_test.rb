require "test_helper"

class PersonRuleFieldsComponentTest < ViewComponent::TestCase
  setup do
    @account = Fabricate(:account)
    prepare_test_goal(@account, "PersonRule") # Now yields a Rule builder
  end

  test "renders the person rule fields" do
    render_inline(PersonRuleFieldsComponent.new(
      form: @rule_form,
      traits: @traits,
      state: "initial"
    ))
    assert_selector "input.rule-type-field[value='PersonRule']", visible: :all
    assert_selector "select[data-people-rule-builder-target='traitSelector']", visible: :all
  end
end
