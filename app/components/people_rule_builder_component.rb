class PeopleRuleBuilderComponent < ViewComponent::Base
  def initialize(account:)
    @account = account
    @client_applications ||= @account.client_applications
    @traits ||= fetch_all_traits
  end

  def fetch_all_traits
    Trait.joins(:client_application_traits)
         .where(client_application_traits: { client_application_id: client_applications.pluck(:id) })
         .select("traits.id, traits.name, client_application_traits.client_application_id")
         .distinct
  end

  private

  attr_reader :client_applications, :traits
end
