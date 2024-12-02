require "test_helper"

class GoalsControllerTest < ActionDispatch::IntegrationTest
  # setup do
  #   @account = Fabricate(:account)  # Ensure an account is set up for the goal
  # end
  #
  # test "should get new goal form" do
  #   get new_goal_url
  #   assert_response :success
  #   assert_select "form"  # Ensures the form is rendered
  # end
  #
  # test "should create goal with name, description, and valid data" do
  #   assert_difference("Goal.count", 1) do
  #     post goals_url, params: {
  #       goal: {
  #         name: "Pre-Diabetic Engagement",
  #         description: "This goal is to help identify pre-diabetic people.",
  #         account_id: @account.id,  # Include the account
  #         data: valid_goal_data  # Ensure data is passed and valid
  #       }
  #     }
  #   end
  #
  #   goal = Goal.last
  #   assert_redirected_to goal_url(goal)
  #   follow_redirect!
  #   assert_select "h1", text: /Pre-Diabetic Engagement/  # Confirms the goal name is displayed
  #   assert_select "p", text: /identify pre-diabetic people/  # Confirms the description is displayed
  # end
  #
  # test "should show goal" do
  #   goal = Goal.create!(
  #     name: "Pre-Diabetic Engagement",
  #     description: "This goal is to help identify pre-diabetic people.",
  #     account: @account,  # Ensure an account is associated
  #     data: valid_goal_data
  #   )
  #
  #   get goal_url(goal)
  #   assert_response :success
  #   assert_select "h1", text: /Pre-Diabetic Engagement/  # Verifies the goal name
  #   assert_select "p", text: /identify pre-diabetic people/  # Verifies the description
  # end
  #
  # test "should get index" do
  #   Goal.create!(
  #     name: "Pre-Diabetic Engagement",
  #     description: "This goal is to help identify pre-diabetic people.",
  #     account: @account,  # Ensure an account is associated
  #     data: valid_goal_data
  #   )
  #   Goal.create!(
  #     name: "Diabetes Risk Engagement",
  #     description: "This goal is to engage with people at risk for diabetes.",
  #     account: @account,
  #     data: valid_goal_data
  #   )
  #
  #   get goals_url
  #   assert_response :success
  #   assert_select "td", text: /Pre-Diabetic Engagement/  # Verifies the first goal in the list
  #   assert_select "td", text: /Diabetes Risk Engagement/  # Verifies the second goal in the list
  # end
  #
  # ### Errors
  #
  # test "should re-render new with unprocessable_entity status when goal creation fails (HTML)" do
  #   assert_no_difference("Goal.count") do
  #     post goals_url, params: {
  #       goal: {
  #         name: "",  # Invalid: missing name
  #         description: "This goal is to help identify pre-diabetic people.",
  #         account_id: @account.id,
  #         data: valid_goal_data  # Valid data but missing the name
  #       }
  #     }
  #   end
  #
  #   assert_response :unprocessable_entity
  #   assert_select "form"  # Verifies that the form is re-rendered
  #   assert_select "div#error_explanation", text: /Name can't be blank/  # Verifies error message is displayed
  # end
  #
  # test "should re-render new with unprocessable_entity status when goal creation fails (Turbo Stream)" do
  #   assert_no_difference("Goal.count") do
  #     post goals_url, params: {
  #       goal: {
  #         name: "",  # Invalid: missing name
  #         description: "This goal is to help identify pre-diabetic people.",
  #         account_id: @account.id,
  #         data: valid_goal_data  # Valid data but missing the name
  #       },
  #       format: :turbo_stream  # Simulates a Turbo Stream request
  #     }
  #   end
  #
  #   assert_response :unprocessable_entity
  #   assert_match(/turbo-stream/, @response.content_type)  # Verifies response is Turbo Stream
  #   assert_select "form"  # Verifies that the form is re-rendered
  #   assert_select "div#error_explanation", text: /Name can't be blank/  # Verifies error message is displayed
  # end
  #
  # private
  #
  # def valid_goal_data
  #   {
  #     "initial_state" => {
  #       "items" => [
  #         {
  #           "type" => "rule_group",
  #           "operator" => nil,
  #           "items" => [
  #             {
  #               "type" => "rule",
  #               "rule_id" => "1",  # Use a placeholder for the test
  #               "operator" => "AND"  # Operator between the rules
  #             },
  #             {
  #               "type" => "rule",
  #               "rule_id" => "2",  # No operator on the last item in the group
  #               "operator" => nil
  #             }
  #           ]
  #         }
  #       ]
  #     },
  #     "end_state" => {
  #       "items" => [
  #         {
  #           "type" => "rule",
  #           "rule_id" => "3",
  #           "operator" => nil  # No operator for the last rule
  #         }
  #       ]
  #     }
  #   }.to_json
  # end
end
