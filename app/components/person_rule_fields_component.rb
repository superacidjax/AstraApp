class PersonRuleFieldsComponent < ViewComponent::Base
  def initialize(form:, traits:, state:)
    @form = form
    @traits = traits
    @state = state
  end

  private

  attr_reader :form, :traits, :state
end
