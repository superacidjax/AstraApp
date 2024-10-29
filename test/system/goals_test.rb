require "application_system_test_case"

class GoalsTest < ApplicationSystemTestCase
  setup do
    @account = Fabricate(:account)
    @client_application = Fabricate(:client_application, account: @account)
    @trait_text = Fabricate(:trait, account: @account, value_type: "text")
    @trait_numeric = Fabricate(:trait, account: @account, value_type: "numeric")
    @trait_boolean = Fabricate(:trait, account: @account, value_type: "boolean")

    @client_application.traits << [ @trait_text, @trait_numeric, @trait_boolean ]

    visit new_goal_path
  end

  test "create a goal with numeric trait and within_range operator" do
    fill_in "Name", with: "Numeric Goal"
    fill_in "Description", with: "Test numeric trait goal"

    # Add initial state rule
    within(:css, "#initial-state-items + div") do
      assert_selector("a", text: "Add New Person Rule")
      click_link "Add New Person Rule"
    end

    within("#initial-state-items") do
      # Fill in the Rule Name
      assert_selector("input[name$='[name]']", visible: true)
      find("input[name$='[name]']").set("Initial State Numeric Rule")

      # Select the client application
      assert_selector("select[name$='[client_application_ids][]']", visible: true)
      find("select[name$='[client_application_ids][]']").find("option", text: @client_application.name).select_option

      # Select the numeric trait
      assert_selector("select[name$='[trait_id]']", visible: true)
      find("select[name$='[trait_id]']").find("option", text: @trait_numeric.name).select_option

      # Select "Within range" for the trait operator
      assert_selector("select[name$='[trait_operator]']", visible: true)
      find("select[name$='[trait_operator]']").select "Within range"

      # Fill in the numeric range values
      assert_selector("input[name$='[trait_value][from]']", visible: true)
      find("input[name$='[trait_value][from]']").set("28")

      assert_selector("input[name$='[trait_value][to]']", visible: true)
      find("input[name$='[trait_value][to]']").set("35")

      # Check the "Values inclusive" checkbox
      assert_selector("input[name$='[trait_value][inclusive]']", visible: true)
      find("input[name$='[trait_value][inclusive]']").check
    end

    # Add end state rule
    within(:css, "#end-state-items + div") do
      assert_selector("a", text: "Add New Person Rule")
      click_link "Add New Person Rule"
    end

    within("#end-state-items") do
      # Fill in the Rule Name
      assert_selector("input[name$='[name]']", visible: true)
      find("input[name$='[name]']").set("End State Numeric Rule")

      # Select the client application
      assert_selector("select[name$='[client_application_ids][]']", visible: true)
      find("select[name$='[client_application_ids][]']").find("option", text: @client_application.name).select_option

      # Select the numeric trait
      assert_selector("select[name$='[trait_id]']", visible: true)
      find("select[name$='[trait_id]']").find("option", text: @trait_numeric.name).select_option

      # Select "Less than" for the trait operator
      assert_selector("select[name$='[trait_operator]']", visible: true)
      find("select[name$='[trait_operator]']").select "Less than"

      # Fill in the numeric value
      assert_selector("input[name$='[trait_value][value]']", visible: true)
      find("input[name$='[trait_value][value]']").set("28")
    end

    # Save the goal
    click_on "Save Goal"

    # Validate successful creation
    assert_text "Goal created."
    assert_text "Numeric Goal"
  end
end
