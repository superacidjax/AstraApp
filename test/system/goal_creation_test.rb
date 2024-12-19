require "application_system_test_case"

class GoalCreationTest < ApplicationSystemTestCase
  setup do
    @account = Fabricate(:account)
    @user = Fabricate(:user)
    Fabricate(:account_user, account: @account, user: @user)

    @trait_numeric = Fabricate(:trait, account: @account, name: "BMI", value_type: :numeric)
    @trait_text = Fabricate(:trait, account: @account, name: "Allergy", value_type: :text)
    @trait_boolean = Fabricate(:trait, account: @account, name: "Smoker", value_type: :boolean)
    @trait_datetime = Fabricate(:trait, account: @account, name: "Last Visit", value_type: :datetime)
  end

  test "numeric less than (initial) and text equals (end)" do
    visit new_goal_path

    fill_in "Name", with: "Health Improvement Goal"
    fill_in "Description", with: "Reduce BMI and ensure allergy is Peanut"

    within("[data-test-id='initial-state-section']") do
      fill_in "Name", with: "BMI < 25"
      find("select[id^=traits_]").select("BMI")
      find("select[id^=operator_]").select("Less than")
      fill_in "Value (Numeric)", with: "25"
    end

    within("[data-test-id='end-state-section']") do
      fill_in "Name", with: "Allergy = Peanut"
      find("select[id^=traits_]").select("Allergy")
      find("select[id^=operator_]").select("Equals")
      fill_in "Value (Text)", with: "Peanut"
    end

    click_button "Save Goal"

    assert_selector "h1", text: "Health Improvement Goal"
    assert_text "Goal was successfully created."
    assert_text "BMI < 25"
    assert_text "Allergy = Peanut"
  end

  test "numeric within range (initial) and boolean is (end)" do
    visit new_goal_path

    fill_in "Name", with: "BMI and Smoker Status Goal"
    fill_in "Description", with: "Check BMI within range and user is a smoker"

    within("[data-test-id='initial-state-section']") do
      fill_in "Name", with: "BMI between 18 and 25"
      find("select[id^=traits_]").select("BMI")
      find("select[id^=operator_]").select("Within range")
      fill_in "From", with: "18"
      fill_in "To", with: "25"
      check "Values inclusive"
    end

    within("[data-test-id='end-state-section']") do
      fill_in "Name", with: "User is Smoker"
      find("select[id^=traits_]").select("Smoker")
      find("select[id^=operator_]").select("Is")
      find("select[id^=boolean_value_]").select("True")
    end

    click_button "Save Goal"

    assert_selector "h1", text: "BMI and Smoker Status Goal"
    assert_text "Goal was successfully created."
    assert_text "BMI between 18 and 25"
    assert_text "User is Smoker"
  end

  test "numeric greater than (initial) and text contains (end)" do
    visit new_goal_path

    fill_in "Name", with: "Weight and Allergy Check"
    fill_in "Description", with: "Ensure BMI > 30 and Allergy contains 'Nut'"

    within("[data-test-id='initial-state-section']") do
      fill_in "Name", with: "BMI > 30"
      find("select[id^=traits_]").select("BMI")
      find("select[id^=operator_]").select("Greater than")
      fill_in "Value (Numeric)", with: "30"
    end

    within("[data-test-id='end-state-section']") do
      fill_in "Name", with: "Allergy contains Nut"
      find("select[id^=traits_]").select("Allergy")
      find("select[id^=operator_]").select("Contains")
      fill_in "Value (Text)", with: "Nut"
      check "Case sensitive" # Testing case sensitivity
    end

    click_button "Save Goal"

    assert_selector "h1", text: "Weight and Allergy Check"
    assert_text "Goal was successfully created."
    assert_text "BMI > 30"
    assert_text "Allergy contains Nut"
  end

  test "text does not contain (initial) and numeric equal to (end)" do
    visit new_goal_path

    fill_in "Name", with: "Allergy Avoidance and BMI Match"
    fill_in "Description", with: "Allergy does not contain 'Peanut' and BMI = 22"

    within("[data-test-id='initial-state-section']") do
      fill_in "Name", with: "Allergy not Peanut"
      find("select[id^=traits_]").select("Allergy")
      find("select[id^=operator_]").select("Does not contain")
      fill_in "Value (Text)", with: "Peanut"
    end

    within("[data-test-id='end-state-section']") do
      fill_in "Name", with: "BMI = 22"
      find("select[id^=traits_]").select("BMI")
      find("select[id^=operator_]").select("Equal to")
      fill_in "Value (Numeric)", with: "22"
    end

    click_button "Save Goal"

    assert_selector "h1", text: "Allergy Avoidance and BMI Match"
    assert_text "Goal was successfully created."
    assert_text "Allergy not Peanut"
    assert_text "BMI = 22"
  end

  test "boolean is not (initial) and datetime before (end)" do
    visit new_goal_path

    fill_in "Name", with: "Non-Smoker and Visit Time Goal"
    fill_in "Description", with: "Check user is not a smoker and last visit before 2020-01-01"

    within("[data-test-id='initial-state-section']") do
      fill_in "Name", with: "User is not Smoker"
      find("select[id^=traits_]").select("Smoker")
      find("select[id^=operator_]").select("Is not")
      find("select[id^=boolean_value_]").select("False")
    end

    within("[data-test-id='end-state-section']") do
      fill_in "Name", with: "Last Visit before 2020"
      find("select[id^=traits_]").select("Last Visit")
      find("select[id^=operator_]").select("Before")
      # datetime_local_field: "YYYY-MM-DDTHH:MM"
      fill_in "Value (Datetime)", with: "2019-12-31T23:59"
    end

    click_button "Save Goal"

    assert_selector "h1", text: "Non-Smoker and Visit Time Goal"
    assert_text "Goal was successfully created."
    assert_text "User is not Smoker"
    assert_text "Last Visit before 2020"
  end

  test "datetime after (initial) and datetime within range (end)" do
    visit new_goal_path

    fill_in "Name", with: "Visit After and Within Range Goal"
    fill_in "Description", with: "Check last visit after 2021-01-01 and then within 2021"

    within("[data-test-id='initial-state-section']") do
      fill_in "Name", with: "Last Visit after 2021 start"
      find("select[id^=traits_]").select("Last Visit")
      find("select[id^=operator_]").select("After")
      fill_in "Value (Datetime)", with: "2021-01-01T00:00"
    end

    within("[data-test-id='end-state-section']") do
      fill_in "Name", with: "Last Visit within 2021"
      find("select[id^=traits_]").select("Last Visit")
      find("select[id^=operator_]").select("Within range")
      fill_in "From", with: "2021-01-01T00:00"
      fill_in "To", with: "2021-12-31T23:59"
      check "Values inclusive"
    end

    click_button "Save Goal"

    assert_selector "h1", text: "Visit After and Within Range Goal"
    assert_text "Goal was successfully created."
    assert_text "Last Visit after 2021 start"
    assert_text "Last Visit within 2021"
  end
end
