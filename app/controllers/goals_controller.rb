class GoalsController < ApplicationController
  before_action :set_goal, only: [ :show, :edit, :update, :destroy ]

  def index
    @goals = current_account.goals
                            .includes(:goal_rules, :rules)
                            .order(created_at: :desc)
  end

  def show; end

  def new
    @goal = current_account.goals.new
    load_form_data
    build_default_goal_rules(@goal)
    render_goal_form(url: goals_path, method: :post)
  end

  def create
    @goal = current_account.goals.new(goal_params)
    assign_account_to_rules(@goal)
    if @goal.save
      redirect_to @goal, notice: "Goal was successfully created."
    else
      handle_form_failure("There were errors creating the goal.",
                          url: goals_path, method: :post)
    end
  end

  def edit
    ensure_goal_rules
    load_form_data
    render_goal_form(url: goal_path(@goal), method: :patch)
  end

  def update
    if @goal.update(goal_params)
      redirect_to @goal, notice: "Goal was successfully updated."
    else
      handle_form_failure("There were errors updating the goal.",
                          url: goal_path(@goal), method: :patch)
    end
  end

  def destroy
    @goal.destroy
    redirect_to goals_path, notice: "Goal was successfully destroyed."
  end

  private

  def set_goal
    @goal = current_account.goals.find(params[:id]) if params[:id]
  end

  def ensure_goal_rules
    build_default_goal_rules(@goal)
  end

  def build_default_goal_rules(goal)
    build_rule_if_none(goal, :initial, "PersonRule")
    build_rule_if_none(goal, :end, "PersonRule")
  end

  def build_rule_if_none(goal, state, rule_type)
    return unless goal.goal_rules.where(state: state).count.zero?

    gr = goal.goal_rules.build(state: state)
    gr.build_rule(type: rule_type)
  end

  def assign_account_to_rules(goal)
    goal.goal_rules.each do |gr|
      gr.rule.account = current_account if gr.rule
    end
  end

  def goal_params
    params.require(:goal).permit(
      :name,
      :description,
      :success_rate,
      goal_rules_attributes: [
        :id,
        :state,
        :_destroy,
        rule_attributes: [
          :id,
          :type,
          :name,
          :ruleable_id,
          :ruleable_type,
          :operator,
          :value,
          :from,
          :to,
          :inclusive,
          :occurrence_operator,
          :datetime_from,
          :datetime_to,
          :occurrence_inclusive,
          :case_sensitive
        ]
      ]
    )
  end

  def get_traits
    Trait.where(account_id: current_account.id)
         .select(:id, :name, :value_type)
  end

  def load_form_data
    @traits = get_traits.map { |t| { id: t.id, name: t.name,
                                     value_type: t.value_type } }
  end

  def render_goal_form(url:, method:, status: nil)
    render GoalFormComponent.new(
      goal: @goal,
      url: url,
      method: method,
      current_account: current_account,
      traits: @traits
    ), status: status
  end

  def handle_form_failure(message, url:, method:)
    load_form_data
    flash.now[:alert] = message
    render_goal_form(url: url, method: method, status: :unprocessable_entity)
  end
end
