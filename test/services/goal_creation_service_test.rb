require "test_helper"

class GoalCreationServiceTest < ActiveSupport::TestCase
  include GoalDataHelper

  setup do
    @account = Fabricate(:account)
    @client_application = Fabricate(:client_application, account: @account)

    # Fabricating traits and properties for use in rules
    @trait_text = Fabricate(:trait, account: @account, value_type: "text")
    @trait_numeric = Fabricate(:trait, account: @account, value_type: "numeric")
    @trait_boolean = Fabricate(:trait, account: @account, value_type: "boolean")

    @property_numeric = Fabricate(:property, event: Fabricate(:event, client_application: @client_application), value_type: "numeric")
    @property_datetime = Fabricate(:property, event: Fabricate(:event, client_application: @client_application), value_type: "datetime")

    @goal = Goal.create!(
      name: "Complex Engagement Goal",
      description: "A complex goal with multiple rules and rule groups",
      account: @account,
      data: valid_goal_data(
        trait_text: @trait_text,
        trait_numeric: @trait_numeric,
        trait_boolean: @trait_boolean,
        property_numeric: @property_numeric,
        property_datetime: @property_datetime
      )
    )
  end

  test "should create goal with valid nested data for rules and rule groups" do
    assert_difference -> { Goal.count }, 0 do
      assert_difference -> { Rule.count }, 11 do
        assert_difference -> { GoalRule.count }, 11 do
          assert_difference -> { RuleGroup.count }, 7 do
            assert_difference -> { GoalRuleGroup.count }, 7 do
              assert_difference -> { RuleGroupMembership.count }, 4 do
                GoalCreationService.new(@goal).call
              end
            end
          end
        end
      end
    end

    assert_equal 11, @goal.rules.count
    assert_equal 7, @goal.rule_groups.count

    assert_equal 5, @goal.goal_rules.where(state: "initial").count
    assert_equal 6, @goal.goal_rules.where(state: "end").count

    assert_equal 3, @goal.goal_rule_groups.where(state: "initial").count
    assert_equal 4, @goal.goal_rule_groups.where(state: "end").count

    parent_groups = RuleGroup.where(id: @goal.goal_rule_groups.map(&:rule_group_id))
    assert_equal 7, parent_groups.count
    child_groups = RuleGroup.joins(:rule_group_memberships).where(rule_group_memberships: { parent_group_id: parent_groups.pluck(:id) })
    assert_equal 4, child_groups.count
    assert_equal 4, RuleGroupMembership.count
  end
end
