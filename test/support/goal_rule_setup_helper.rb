module GoalRuleSetupHelper
  def prepare_test_goal(account, rule_type)
    @goal = account.goals.new(name: "Test Goal")
    goal_rule = @goal.goal_rules.build(state: "initial")
    goal_rule.build_rule(type: rule_type)

    view_context = ActionView::Base.new(
      ActionController::Base.view_paths,
      {},
      ApplicationController.new
    )
    view_context.class_eval do
      include Rails.application.routes.url_helpers
      include ActionView::Helpers::FormHelper
      include ActionView::Helpers::FormOptionsHelper
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::UrlHelper
    end

    form_builder = ActionView::Helpers::FormBuilder.new(:goal, @goal, view_context, {})
    @rule_form = nil
    form_builder.fields_for(:goal_rules, @goal.goal_rules) do |gr_form|
      @rule_form = gr_form if gr_form.object.state == "initial"
    end

    raise "Expected a rule form for the initial state" unless @rule_form
  end
end

class ActiveSupport::TestCase
  include GoalRuleSetupHelper
end
