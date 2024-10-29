# app/controllers/goals_controller.rb

class GoalsController < ApplicationController
  before_action :set_current_account
  before_action :load_form_data, only: [:new, :create, :add_initial_state_goal_rule, :add_end_state_goal_rule]

  def new
    @goal = Goal.new
    # Build an empty goal_rule to render existing fields if any
    @goal.goal_rules.build.build_rule
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.account = @current_account

    ActiveRecord::Base.transaction do
      if @goal.save
        # Build goal.data with goal_rule IDs and operators
        @goal.update!(data: build_goal_data(@goal))
        GoalCreationService.new(@goal).call

        respond_to do |format|
          format.html { redirect_to @goal, notice: "Goal created." }
          format.turbo_stream { flash.now[:notice] = "Goal created." }
        end
      else
        load_form_data
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }
          format.turbo_stream { render :new, status: :unprocessable_entity }
        end
      end
    end
  end

  def add_initial_state_goal_rule
    @state = 'initial'
    @goal_rule = GoalRule.new(state: @state)
    @goal_rule.build_rule

    respond_to do |format|
      format.turbo_stream
    end
  end

  def add_end_state_goal_rule
    @state = 'end'
    @goal_rule = GoalRule.new(state: @state)
    @goal_rule.build_rule

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_current_account
    @current_account = Account.first
  end

  def load_form_data
    @client_applications = @current_account.client_applications
    @traits = get_traits
    @client_application_options = @client_applications.map { |app| [ app.name, app.id ] }
  end

  def get_traits
    Trait.joins(:client_application_traits)
         .where(client_application_traits: { client_application_id: @current_account.client_applications.ids })
         .select(:id, :name, :value_type, :client_application_id)
         .distinct
  end

  def goal_params
    params.require(:goal).permit(
      :name,
      :description,
      goal_rules_attributes: [
        :id,
        :operator,
        :state,
        :_destroy,
        rule_attributes: [
          :id,
          :name,
          :type,
          { client_application_ids: [] },
          :trait_id,
          :trait_operator,
          :trait_value_text,
          :trait_value_value,
          :trait_value_from,
          :trait_value_to,
          :trait_value_inclusive,
          :trait_value_boolean,
          :trait_value_datetime,
          :_destroy
        ]
      ]
    )
  end

  def build_goal_data(goal)
    initial_state_items = goal.goal_rules.where(state: 'initial').order(:created_at).map do |goal_rule|
      {
        "goal_rule_id" => goal_rule.id,
        "operator" => goal_rule.operator
      }
    end

    end_state_items = goal.goal_rules.where(state: 'end').order(:created_at).map do |goal_rule|
      {
        "goal_rule_id" => goal_rule.id,
        "operator" => goal_rule.operator
      }
    end

    {
      "initial_state" => { "items" => initial_state_items },
      "end_state"     => { "items" => end_state_items }
    }
  end
end
