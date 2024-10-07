require "test_helper"

class GoalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = Fabricate(:account)
    @client_application = Fabricate(:client_application, account: @account)
    
    # Fabricating traits and properties for use in rules
    @trait_text = Fabricate(:trait, account: @account, value_type: "text")
    @trait_numeric = Fabricate(:trait, account: @account, value_type: "numeric")
    @trait_boolean = Fabricate(:trait, account: @account, value_type: "boolean")

    @property_numeric = Fabricate(:property, event: Fabricate(:event, client_application: @client_application), value_type: "numeric")
    @property_datetime = Fabricate(:property, event: Fabricate(:event, client_application: @client_application), value_type: "datetime")
  end

  test "should create goal with valid nested data for rules and rule groups" do
    assert_difference -> { Goal.count }, 1 do
      assert_difference -> { Rule.count }, 11 do
        assert_difference -> { GoalRule.count }, 11 do
          assert_difference -> { RuleGroup.count }, 7 do
            assert_difference -> { GoalRuleGroup.count }, 7 do
              assert_difference -> { RuleGroupMembership.count }, 4 do
                post goals_url, params: {
                  goal: {
                    name: "Complex Engagement Goal",
                    description: "A complex goal with multiple rules and rule groups",
                    account_id: @account.id,
                    data: valid_goal_data  # Ensure this structure is correct
                  }
                }
              end
            end
          end
        end
      end
    end

    goal = Goal.last
    assert_equal "Complex Engagement Goal", goal.name

    # Verify rules and rule groups were created correctly
    assert_equal 11, goal.rules.count
    assert_equal 7, goal.rule_groups.count

    # Check goal_rule states
    assert_equal 5, goal.goal_rules.where(state: "initial").count
    assert_equal 6, goal.goal_rules.where(state: "end").count

    # Check goal_rule_groups states
    assert_equal 3, goal.goal_rule_groups.where(state: "initial").count
    assert_equal 4, goal.goal_rule_groups.where(state: "end").count

    # Check parent and child groups
    parent_groups = RuleGroup.where(id: goal.goal_rule_groups.map(&:rule_group_id))
    assert_equal 7, parent_groups.count  # 2 parent groups
    child_groups = RuleGroup.joins(:rule_group_memberships).where(rule_group_memberships: { parent_group_id: parent_groups.pluck(:id) })
    assert_equal 4, child_groups.count  # 3 child groups

    # Ensure rule group memberships are correct
    assert_equal 4, RuleGroupMembership.count
  end

  private

  def valid_goal_data
  {
    "initial_state" => {
      "items" => [
        {
          "type" => "rule_group",
          "name" => "Group 1",
          "operator" => "AND",
          "items" => [
            {
              "type" => "rule_group",
              "name" => "Group 1.1",
              "operator" => "OR",
              "items" => [
                {
                  "type" => "rule",
                  "name" => "Rule 1",
                  "data" => { "trait_operator" => "Equals", "trait_value" => "some value" },
                  "ruleable" => { "type" => "trait", "value_type" => "text", "id" => @trait_text.id },
                  "operator" => "AND"
                },
                {
                  "type" => "rule",
                  "name" => "Rule 2",
                  "data" => { "property_operator" => "Greater than", "property_value" => "100" }, # No 'inclusive' key needed
                  "ruleable" => { "type" => "property", "value_type" => "numeric", "id" => @property_numeric.id },
                  "operator" => nil
                }
              ]
            },
            {
              "type" => "rule_group",
              "name" => "Group 1.2",
              "items" => [
                {
                  "type" => "rule",
                  "name" => "Rule 3",
                  "data" => { "trait_operator" => "Contains", "trait_value" => "keyword" },
                  "ruleable" => { "type" => "trait", "value_type" => "text", "id" => @trait_text.id },
                  "operator" => "OR"
                },
                {
                  "type" => "rule",
                  "name" => "Rule 4",
                  "data" => { "property_operator" => "Less than", "property_value" => "50" }, # No 'inclusive' key needed
                  "ruleable" => { "type" => "property", "value_type" => "numeric", "id" => @property_numeric.id },
                  "operator" => nil
                }
              ]
            }
          ]
        },
        {
          "type" => "rule",
          "name" => "Rule 5",
          "data" => { "trait_operator" => "Is", "trait_value" => "true" },
          "ruleable" => { "type" => "trait", "value_type" => "boolean", "id" => @trait_boolean.id },
          "operator" => nil
        }
      ]
    },
    "end_state" => {
      "items" => [
        {
          "type" => "rule_group",
          "name" => "Group 2",
          "operator" => "OR",
          "items" => [
            {
              "type" => "rule",
              "name" => "Rule 6",
              "data" => { "property_operator" => "Within range", "property_from" => "20", "property_to" => "100", "property_inclusive" => true }, # 'inclusive' added
              "ruleable" => { "type" => "property", "value_type" => "numeric", "id" => @property_numeric.id },
              "operator" => "OR"
            },
            {
              "type" => "rule_group",
              "name" => "Group 2.1",
              "items" => [
                {
                  "type" => "rule",
                  "name" => "Rule 7",
                  "data" => { "trait_operator" => "Greater than", "trait_value" => "5" }, # No 'inclusive' key needed
                  "ruleable" => { "type" => "trait", "value_type" => "numeric", "id" => @trait_numeric.id },
                  "operator" => "AND"
                },
                {
                  "type" => "rule",
                  "name" => "Rule 8",
                  "data" => { "property_operator" => "Before", "property_value" => "2024-01-01T00:00:00+00:00" }, # No 'inclusive' key needed
                  "ruleable" => { "type" => "property", "value_type" => "datetime", "id" => @property_datetime.id },
                  "operator" => nil
                }
              ]
            }
          ]
        },
        {
          "type" => "rule_group",
          "name" => "Group 3",
          "items" => [
            {
              "type" => "rule",
              "name" => "Rule 9",
              "data" => { "trait_operator" => "Not equals", "trait_value" => "some other value" }, # No 'inclusive' key needed
              "ruleable" => { "type" => "trait", "value_type" => "text", "id" => @trait_text.id },
              "operator" => "OR"
            },
            {
              "type" => "rule_group",
              "name" => "Group 3.1",
              "operator" => nil,
              "items" => [
                {
                  "type" => "rule",
                  "name" => "Rule 10",
                  "data" => { "trait_operator" => "Is not", "trait_value" => "false" }, # No 'inclusive' key needed
                  "ruleable" => { "type" => "trait", "value_type" => "boolean", "id" => @trait_boolean.id },
                  "operator" => "AND"
                },
                {
                  "type" => "rule",
                  "name" => "Rule 11",
                  "data" => { "property_operator" => "After", "property_value" => "2024-12-31T23:59:59+00:00" }, # No 'inclusive' key needed
                  "ruleable" => { "type" => "property", "value_type" => "datetime", "id" => @property_datetime.id },
                  "operator" => nil
                }
              ]
            }
          ]
        }
      ]
    }
  }.to_json
end
  end
