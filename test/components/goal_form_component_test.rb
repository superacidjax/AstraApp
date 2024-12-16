require "test_helper"

class GoalFormComponentTest < ViewComponent::TestCase
  setup do
    @account = Fabricate(:account)
    @goal = @account.goals.new
    @traits = [
      {
        id: "1",
        name: "BMI",
        value_type: "numeric"
      },
      {
        id: "2",
        name: "Allergy",
        value_type: "text"
      }
    ]

    @component = GoalFormComponent.new(
      goal: @goal,
      url: "/goals",
      method: :post,
      current_account: @account,
      traits: @traits,
    )
  end

  test "renders form fields" do
    render_inline(@component)
    assert_selector "form"
    assert_selector "input[name='goal[name]']"
    assert_selector "textarea[name='goal[description]']"

    assert_selector "h2", text: "Initial State"
    assert_selector "h2", text: "End State"
  end
end
