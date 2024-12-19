class ActionFormComponent < ViewComponent::Base
  def initialize(action_record:, url:, method:, action_types:)
    @action_record = action_record
    @url = url
    @method = method
    @action_types = action_types
  end
end
