class GoalsController < ApplicationController
  before_action :set_goal, only: [ :show, :edit, :update, :destroy ]

  def index
    @goals = current_account.goals.includes(:goal_rules, :rules).order(created_at: :desc)
  end

  def show
  end

  def new
    @goal = current_account.goals.new
    initial_goal_rule = @goal.goal_rules.build(state: :initial)
    initial_goal_rule.build_rule(type: "PersonRule") # or "EventRule", depending on default selection

    end_goal_rule = @goal.goal_rules.build(state: :end)
    end_goal_rule.build_rule(type: "EventRule") # or "PersonRule"

    render GoalFormComponent.new(goal: @goal, url: goals_path,
                                 method: :post, current_account: current_account)
  end

  def create
    @goal = current_account.goals.new(goal_params)
    @goal.goal_rules.each do |gr|
      gr.rule.account = current_account if gr.rule
    end
    if @goal.save
      redirect_to @goal, notice: "Goal was successfully created."
    else
      flash.now[:alert] = "There were errors creating the goal."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    ensure_goal_rules
    render GoalFormComponent.new(goal: @goal, url: goal_path(@goal),
                                 method: :patch, current_account: current_account)
  end

  def update
    if @goal.update(goal_params)
      redirect_to @goal, notice: "Goal was successfully updated."
    else
      flash.now[:alert] = "There were errors updating the goal."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @goal.destroy
    redirect_to goals_path, notice: "Goal was successfully destroyed."
  end

  private

  def set_goal
    @goal = current_account.goals.find(params[:id])
  end

  def ensure_goal_rules
    if @goal.goal_rules.initial.count.zero?
      gr = @goal.goal_rules.build(state: :initial)
      gr.build_rule(type: "PersonRule") # or "EventRule" as needed
    end

    if @goal.goal_rules.end.count.zero?
      gr = @goal.goal_rules.build(state: :end)
      gr.build_rule(type: "EventRule") # or "PersonRule" as needed
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
end
