class PeopleRuleBuilderComponent < ViewComponent::Base
  def initialize(account:, traits:, client_applications:, form_builder:, state:)
    @account = account
    @traits = traits
    @client_applications = client_applications
    @form_builder = form_builder
    @state = state
  end

  def client_application_options
    [["All Applications", "all"]] + client_applications.map { |app| [app.name, app.id] }
  end

  def render_rule_fields
    @form_builder.fields_for :items do |item_fields|
      render_rule_or_group(item_fields)
    end
  end

  private

  def render_rule_or_group(item_fields)
    if item_fields.object["type"] == "rule"
      render_rule(item_fields)
    elsif item_fields.object["type"] == "rule_group"
      render_rule_group(item_fields)
    end
  end

  attr_reader :account, :traits, :client_applications, :form_builder, :state
end
