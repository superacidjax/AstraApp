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

    initial_rule = @goal.goal_rules.build(state: :initial)
    initial_rule.build_rule(type: "PersonRule")

    end_rule = @goal.goal_rules.build(state: :end)
    end_rule.build_rule(type: "PersonRule")

    render GoalFormComponent.new(
      goal: @goal,
      url: goals_path,
      method: :post,
      current_account: current_account,
      traits: @traits
    )
  end

  def create
    @goal = current_account.goals.new(goal_params)
    @goal.goal_rules.each do |gr|
      gr.rule.account = current_account if gr.rule
    end
    if @goal.save
      redirect_to @goal, notice: "Goal was successfully created."
    else
      load_form_data
      flash.now[:alert] = "There were errors creating the goal."
      render GoalFormComponent.new(
        goal: @goal,
        url: goals_path,
        method: :post,
        current_account: current_account,
        traits: @traits
      ), status: :unprocessable_entity
    end
  end

  def edit
    ensure_goal_rules
    load_form_data
    render GoalFormComponent.new(
      goal: @goal,
      url: goal_path(@goal),
      method: :patch,
      current_account: current_account,
      traits: @traits
    )
  end

  def update
    if @goal.update(goal_params)
      redirect_to @goal, notice: "Goal was successfully updated."
    else
      load_form_data
      flash.now[:alert] = "There were errors updating the goal."
      render GoalFormComponent.new(
        goal: @goal,
        url: goal_path(@goal),
        method: :patch,
        current_account: current_account,
        traits: @traits
      ), status: :unprocessable_entity
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
    if @goal.goal_rules.initial.count.zero?
      gr = @goal.goal_rules.build(state: :initial)
      gr.build_rule(type: "PersonRule")
    end

    if @goal.goal_rules.end.count.zero?
      gr = @goal.goal_rules.build(state: :end)
      gr.build_rule(type: "EventRule")
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
    @traits = get_traits.map do |t|
      {
        id: t.id,
        name: t.name,
        value_type: t.value_type
      }
    end
  end
end
