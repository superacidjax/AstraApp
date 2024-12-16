class RuleBuilderComponent < ViewComponent::Base
  def initialize(form:, current_account:, traits: [])
    @form = form
    @current_account = current_account
    @traits = traits
  end

  private

  attr_reader :form, :current_account, :traits
end
