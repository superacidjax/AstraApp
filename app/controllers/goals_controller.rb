class GoalsController < ApplicationController
  before_action :set_current_account

  def new
    @goal = Goal.new
    @goal.goal_rule_groups.build
    @goal.goal_rules.build
    @client_applications = @current_account.client_applications
    @traits = get_traits
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.account = Account.last # Not implemented

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

  def set_current_account
    @current_account = Account.first
  end

  def get_traits
    # add caching
    Trait.joins(:client_application_traits)
      .where(client_application_traits: {
        client_application_id: @current_account.client_applications.ids
      })
        .select(:id, :name, :client_application_id).distinct
  end

  def goal_params
    params.require(:goal).permit(
      :name, :description, :data,
      goal_rules_attributes: [
        :id, :rule_id, :operator, :_destroy
      ],
      goal_rule_groups_attributes: [
        :id, :rule_group_id, :operator, :_destroy,
        rule_group_attributes: [
          :name, :data,
          rule_group_memberships_attributes: [
            :id, :parent_group_id,
            :child_group_id, :operator,
            :_destroy
          ]
        ]
      ]
    ).tap do |whitelisted|
      whitelisted[:data] = params[:goal][:data].permit! if params[:goal][:data].present?
    end
  end
end
