class RuleBuilderComponent < ViewComponent::Base
  def initialize(form:, current_account:)
    @form = form
    @current_account = current_account
  end
end
