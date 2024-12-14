class GoalFormComponent < ViewComponent::Base
  def initialize(goal:, url:, method:, current_account:)
    @goal = goal
    @url = url
    @method = method
    @current_account = current_account
  end

  def render?
    @goal.present?
  end
end
