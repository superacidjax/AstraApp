require "test_helper"

class GoalComponentTest < ViewComponent::TestCase
  include GoalDataHelper

  setup do
    @goal = Fabricate(:goal,
                      name: "Complex Engagement Goal",
                      description: "someDescription",
                      data: valid_goal_data(
                        trait_text: Fabricate(:trait),
                        trait_numeric: Fabricate(:trait),
                        trait_boolean: Fabricate(:trait),
                        property_numeric: Fabricate(:property),
                        property_datetime: Fabricate(:property))
                     )
  end

  test "renders the goal component with valid data" do
    @goal.update!(success_rate: 100.00)
    render_inline(GoalComponent.new(goal: @goal))

    assert_text "Complex Engagement Goal"
    assert_text "100%"
    assert_text "someDescription"

    # Assert for the Audience (initial_state rules)
    assert_text "((Rule 1 AND Rule 2) OR (Rule 3 OR Rule 4)) AND Rule 5"

    # Assert for the Outcome (end_state rules)
    assert_text "(Rule 6 OR (Rule 7 AND Rule 8)) OR (Rule 9 OR (Rule 10 AND Rule 11))"
  end

  test "renders success rate as 0% for 0.00" do
    @goal.update!(success_rate: 0.00)
    render_inline(GoalComponent.new(goal: @goal))

    assert_text "0%"
  end

  test "renders success rate as 100% for 100.00" do
    @goal.update!(success_rate: 100.00)
    render_inline(GoalComponent.new(goal: @goal))

    assert_text "100%"
  end

  test "renders success rate with two decimals for 89.65" do
    @goal.update!(success_rate: 89.65)
    render_inline(GoalComponent.new(goal: @goal))

    assert_text "89.65%"
  end

  test "renders initial state and end state rules" do
    @goal.update!(success_rate: 100.00)
    render_inline(GoalComponent.new(goal: @goal))

    # Check Audience (initial_state)
    assert_text "((Rule 1 AND Rule 2) OR (Rule 3 OR Rule 4)) AND Rule 5"

    # Check Outcome (end_state)
    assert_text "(Rule 6 OR (Rule 7 AND Rule 8)) OR (Rule 9 OR (Rule 10 AND Rule 11))"
  end
end
