class PeopleRuleBuilderComponent < ViewComponent::Base
  def initialize(account:, traits:, client_applications:)
    @account = account
    @traits = traits
    @client_applications = client_applications
  end

  private

  attr_reader :client_applications, :traits
end
