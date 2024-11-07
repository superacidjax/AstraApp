# app/controllers/goals_controller.rb
class GoalsController < ApplicationController
  include GoalsHelper

  def new
    @goal = Goal.new
    @goal.goal_rules.build(rule: Rule.new, state: :initial)
    @goal.goal_rule_groups.build(rule_group: RuleGroup.new, state: :initial)
    @traits = Trait.all # Adjust scope as necessary
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.account = Account.last # Adjust as needed

    @traits = Trait.all

    if @goal.save
      GoalCreationService.new(@goal).call
      respond_to do |format|
        format.html { redirect_to @goal, notice: "Goal created." }
        format.turbo_stream { flash.now[:notice] = "Goal created." }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show
    @goal = Goal.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to goals_url, flash: { danger: "Goal not found" }
  end

  def index
    @goals = Goal.all
  end

  private

  def goal_params
    params.require(:goal).permit(
      :name, :description, :data,
      goal_rule_groups_attributes: [
        :id, :operator, :_destroy,
        rule_group_attributes: [
          :id, :name, :data, :_destroy
        ],
        rules_attributes: [
          :id, :type, :name, :client_application_ids, :trait_id,
          :trait_operator, :trait_value, :trait_from,
          :trait_to, :trait_inclusive, :trait_value_datetime,
          :trait_from_datetime, :trait_to_datetime, :trait_inclusive_datetime,
          :_destroy
        ]
      ]
    ).tap do |whitelisted|
      whitelisted[:data] = params[:goal][:data].permit! if params[:goal][:data].present?
    end
  end
end
