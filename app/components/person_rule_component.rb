class PersonRuleComponent < ViewComponent::Base
  def initialize(form:, unique_id:, traits:, client_application_options:, state:)
    @form = form
    @unique_id = unique_id
    @traits = traits
    @client_application_options = client_application_options
    @state = state
  end

  private

  attr_reader :form, :unique_id, :traits, :client_application_options, :state
end
