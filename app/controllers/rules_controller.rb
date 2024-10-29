class RulesController < ApplicationController
  before_action :set_goal, only: [:new]

  def new
    @state = params[:state]
    @goal_rule = @goal.goal_rules.build(state: @state)
    @goal_rule.build_rule

    load_form_data

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_goal
    @goal = Goal.find(params[:goal_id])
  end

  def load_form_data
    @client_applications = @goal.account.client_applications
    @traits = get_traits
    @client_application_options = @client_applications.map { |app| [ app.name, app.id ] }
  end

  def get_traits
    Trait.joins(:client_application_traits)
         .where(client_application_traits: { client_application_id: @client_applications.ids })
         .select(:id, :name, :value_type, :client_application_id)
         .distinct
  end
end
