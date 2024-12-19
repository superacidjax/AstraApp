class FlowsController < ApplicationController
  before_action :set_flow, only: [ :show, :edit, :update, :destroy ]
  before_action :load_form_data, only: [ :new, :edit, :create, :update ]

  def index
    @flows = current_account.flows.order(created_at: :desc)
  end

  def show
  end

  def new
    @flow = current_account.flows.new
    ensure_associations(@flow)
    render_flow_form(url: flows_path, method: :post)
  end

  def create
    @flow = current_account.flows.new(flow_params)
    if @flow.save
      redirect_to @flow, notice: "Flow was successfully created."
    else
      handle_form_failure("There were errors creating the flow.", url: flows_path, method: :post)
    end
  end

  def edit
    ensure_associations(@flow)
    render_flow_form(url: flow_path(@flow), method: :patch)
  end

  def update
    if @flow.update(flow_params)
      redirect_to @flow, notice: "Flow was successfully updated."
    else
      handle_form_failure("There were errors updating the flow.", url: flow_path(@flow), method: :patch)
    end
  end

  def destroy
    @flow.destroy
    redirect_to flows_path, notice: "Flow was successfully destroyed."
  end

  private

  def set_flow
    @flow = current_account.flows.find(params[:id])
  end

  def load_form_data
    @goals = current_account.goals.order(:name).map { |g| [ g.name, g.id ] }
    @sms_actions = current_account.actions
                                 .where(type: "ActionSms")
                                 .order(:name)
                                 .map { |a| [ a.name, a.id ] }
  end

  def ensure_associations(flow)
    flow.flow_goals.build if flow.flow_goals.empty?
    if flow.flow_actions.empty?
      action_id = @sms_actions.first&.last
      flow.flow_actions.build(type: "FlowActionSms", data: {}, action_id: action_id)
    end
  end

  def flow_params
    params.require(:flow).permit(
      :name,
      flow_goals_attributes: [
        :id,
        :goal_id,
        :_destroy
      ],
      flow_actions_attributes: [
        :id,
        :action_id,
        :_destroy,
        { data: [ :content ] }
      ]
    )
  end

  def render_flow_form(url:, method:, status: nil)
    render FlowFormComponent.new(
      flow: @flow,
      url: url,
      method: method,
      goals: @goals,
      sms_actions: @sms_actions
    ), status: status
  end

  def handle_form_failure(message, url:, method:)
    flash.now[:alert] = message
    render_flow_form(url: url, method: method, status: :unprocessable_entity)
  end
end
