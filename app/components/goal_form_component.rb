class GoalFormComponent < ViewComponent::Base
  def initialize(goal:, url:, method:, current_account:, traits: [])
    @goal = goal
    @url = url
    @method = method
    @current_account = current_account
    @traits = traits
  end

  private

  attr_reader :goal, :url, :method, :current_account, :traits
end
