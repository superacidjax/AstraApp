# test/system/goals_test.rb
require "application_system_test_case"

class GoalsTest < ApplicationSystemTestCase
  include GoalDataHelper

  setup do
    @account = Fabricate(:account)
    @client_application = Fabricate(:client_application, account: @account)
    @trait_text = Fabricate(:trait, account: @account, value_type: "text")
    @trait_numeric = Fabricate(:trait, account: @account, value_type: "numeric")
    @trait_boolean = Fabricate(:trait, account: @account, value_type: "boolean")
    @property_numeric = Fabricate(
      :property, event: Fabricate(
        :event, client_application: @client_application), value_type: "numeric"
    )
    @property_datetime = Fabricate(
      :property, event: Fabricate(
        :event, client_application: @client_application), value_type: "datetime"
    )
  end

  test "creating a Goal with person-based rules and rule groups" do
    visit new_goal_path

    # Fill in Goal Name and Description
    fill_in "Name", with: "Test Goal"
    fill_in "Description", with: "This is a test goal with multiple rules and groups."

    # Initialize Turbo Frames or Stimulus Controllers if necessary
    # Assuming you have buttons to add Initial and End State sections
    # For simplicity, we'll assume sections are already present

    # Fill Initial State
    within("#initial_state") do
      # Add Rule Group 1
      click_button "Add Rule Group"

      within(".rule-group", text: "Group 1") do
        fill_in "Name", with: "Group 1"

        # Add Rule 1
        click_button "Add Rule"
        within(".rule", text: "Rule 1") do
          fill_in "Rule Name", with: "Rule 1"
          select "Trait", from: "Ruleable Type"
          select @trait_text.name, from: "Trait"
          select "Equals", from: "Trait Operator"
          fill_in "Trait Value Text", with: "some value"
          select "AND", from: "Operator"
        end

        # Add Rule 2
        click_button "Add Rule"
        within(".rule", text: "Rule 2") do
          fill_in "Rule Name", with: "Rule 2"
          select "Property", from: "Ruleable Type"
          select @property_numeric.name, from: "Property"
          select "Greater than", from: "Property Operator"
          fill_in "Property Value", with: "100"
          # Last rule in group should not have an operator
          select "", from: "Operator"
        end

        # Ensure the group has at least two rules
      end

      # Add another Rule Group 2 within Group 1
      within(".rule-group", text: "Group 1") do
        click_button "Add Rule Group"

        within(".rule-group", text: "Group 1.1") do
          fill_in "Name", with: "Group 1.1"

          # Add Rule 3
          click_button "Add Rule"
          within(".rule", text: "Rule 3") do
            fill_in "Rule Name", with: "Rule 3"
            select "Trait", from: "Ruleable Type"
            select @trait_text.name, from: "Trait"
            select "Contains", from: "Trait Operator"
            fill_in "Trait Value Text", with: "keyword"
            select "OR", from: "Operator"
          end

          # Add Rule 4
          click_button "Add Rule"
          within(".rule", text: "Rule 4") do
            fill_in "Rule Name", with: "Rule 4"
            select "Property", from: "Ruleable Type"
            select @property_numeric.name, from: "Property"
            select "Less than", from: "Property Operator"
            fill_in "Property Value", with: "50"
            # Last rule in group should not have an operator
            select "", from: "Operator"
          end
        end
      end

      # Add standalone Rule 5 in Initial State
      click_button "Add Rule"
      within(".rule", text: "Rule 5") do
        fill_in "Rule Name", with: "Rule 5"
        select "Trait", from: "Ruleable Type"
        select @trait_boolean.name, from: "Trait"
        select "Is", from: "Trait Operator"
        select "True", from: "Trait Value Boolean"
        # Last rule in initial state should not have an operator
        select "", from: "Operator"
      end
    end

    # Fill End State
    within("#end_state") do
      # Add Rule Group 3
      click_button "Add Rule Group"

      within(".rule-group", text: "Group 2") do
        fill_in "Name", with: "Group 2"

        # Add Rule 6
        click_button "Add Rule"
        within(".rule", text: "Rule 6") do
          fill_in "Rule Name", with: "Rule 6"
          select "Property", from: "Ruleable Type"
          select @property_datetime.name, from: "Property"
          select "Within range", from: "Property Operator"
          fill_in "Property From", with: "20"
          fill_in "Property To", with: "100"
          check "Property Inclusive"
          select "OR", from: "Operator"
        end

        # Add Rule Group 2.1 within Group 2
        click_button "Add Rule Group"

        within(".rule-group", text: "Group 2.1") do
          fill_in "Name", with: "Group 2.1"

          # Add Rule 7
          click_button "Add Rule"
          within(".rule", text: "Rule 7") do
            fill_in "Rule Name", with: "Rule 7"
            select "Trait", from: "Ruleable Type"
            select @trait_numeric.name, from: "Trait"
            select "Greater than", from: "Trait Operator"
            fill_in "Trait Value Numeric", with: "5"
            select "AND", from: "Operator"
          end

          # Add Rule 8
          click_button "Add Rule"
          within(".rule", text: "Rule 8") do
            fill_in "Rule Name", with: "Rule 8"
            select "Property", from: "Ruleable Type"
            select @property_datetime.name, from: "Property"
            select "Before", from: "Property Operator"
            fill_in "Property Value Datetime", with: "2024-01-01T00:00:00"
            # Last rule in group should not have an operator
            select "", from: "Operator"
          end
        end
      end

      # Add Rule Group 3
      click_button "Add Rule Group"

      within(".rule-group", text: "Group 3") do
        fill_in "Name", with: "Group 3"

        # Add Rule 9
        click_button "Add Rule"
        within(".rule", text: "Rule 9") do
          fill_in "Rule Name", with: "Rule 9"
          select "Trait", from: "Ruleable Type"
          select @trait_text.name, from: "Trait"
          select "Not equals", from: "Trait Operator"
          fill_in "Trait Value Text", with: "some other value"
          select "OR", from: "Operator"
        end

        # Add Rule Group 3.1 within Group 3
        click_button "Add Rule Group"

        within(".rule-group", text: "Group 3.1") do
          fill_in "Name", with: "Group 3.1"

          # Add Rule 10
          click_button "Add Rule"
          within(".rule", text: "Rule 10") do
            fill_in "Rule Name", with: "Rule 10"
            select "Trait", from: "Ruleable Type"
            select @trait_boolean.name, from: "Trait"
            select "Is not", from: "Trait Operator"
            select "False", from: "Trait Value Boolean"
            select "AND", from: "Operator"
          end

          # Add Rule 11
          click_button "Add Rule"
          within(".rule", text: "Rule 11") do
            fill_in "Rule Name", with: "Rule 11"
            select "Property", from: "Ruleable Type"
            select @property_datetime.name, from: "Property"
            select "After", from: "Property Operator"
            fill_in "Property Value Datetime", with: "2024-12-31T23:59:59"
            # Last rule in group should not have an operator
            select "", from: "Operator"
          end
        end
      end
    end

    # Submit the form
    click_button "Save Goal"

    # Assertions
    assert_text "Goal created."

    # Verify the Goal is displayed correctly
    assert_text "Test Goal"
    assert_text "This is a test goal with multiple rules and groups."

    # Optionally, verify that all rules and rule groups are present
    # This can be expanded based on how you display the goal details
  end
end
