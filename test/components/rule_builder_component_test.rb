require "test_helper"

class RuleBuilderComponentTest < ViewComponent::TestCase
  setup do
    @account = Fabricate(:account)
    @client_app_1 = Fabricate(:client_application, account: @account, name: "AstraTest1")
    @client_app_2 = Fabricate(:client_application, account: @account, name: "AstraTest2")

    @goal = @account.goals.new(name: "Test Goal", success_rate: 50.0)
    initial_goal_rule = @goal.goal_rules.build(state: "initial")
    initial_goal_rule.build_rule(type: "PersonRule", name: "Initial Rule")

    @view_context = ActionView::Base.new(
      ActionController::Base.view_paths,
      {},
      ApplicationController.new
    )
    @view_context.class_eval do
      include Rails.application.routes.url_helpers
      include ActionView::Helpers::FormHelper
      include ActionView::Helpers::FormOptionsHelper
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::UrlHelper
    end

    form_builder = ActionView::Helpers::FormBuilder.new(:goal, @goal, @view_context, {})

    @initial_rule_form = nil
    form_builder.fields_for(:goal_rules, @goal.goal_rules) do |gr_form|
      if gr_form.object.state == "initial"
        @initial_rule_form = gr_form
      end
    end

    assert @initial_rule_form.present?, "Expected to find an initial goal rule form"
  end

  test "renders the rule builder interface" do
    render_inline(RuleBuilderComponent.new(form: @initial_rule_form, current_account: @account))

    assert_selector "select[multiple][data-rule-builder-target='clientApplications']" do
      assert_selector "option[value='all']", text: "All Applications"
      assert_selector "option", text: "AstraTest1"
      assert_selector "option", text: "AstraTest2"
    end

    assert_selector "ul.nav-tabs" do
      assert_selector "a.nav-link", text: "People"
      assert_selector "a.nav-link", text: "Events"
    end

    assert_selector "#people-rule-tab.tab-pane"

    assert_selector "#event-rule-tab.tab-pane"
  end
end
