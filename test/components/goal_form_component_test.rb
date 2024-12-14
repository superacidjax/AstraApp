require "test_helper"

class GoalFormComponentTest < ViewComponent::TestCase
  setup do
    @account = Fabricate(:account)
    @goal = @account.goals.new
    @component = GoalFormComponent.new(goal: @goal, url: "/goals",
                                       method: :post, current_account: @account)
  end

  test "renders form fields" do
    render_inline(@component)
    assert_selector "form"
    assert_selector "input[name='goal[name]']"
  end
end
