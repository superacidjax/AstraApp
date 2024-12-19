class ActionsController < ApplicationController
  before_action :set_action, only: [ :show, :edit, :update, :destroy ]

  def index
    @actions = current_account.actions.order(:name)
  end

  def show
    render ActionComponent.new(action_record: @action)
  end

  def new
    @action = current_account.actions.new
    render_action_form(url: actions_path, method: :post)
  end

  def create
    @action = current_account.actions.new(action_params)
    if @action.save
      redirect_to action_path(@action), notice: "Action was successfully created."
    else
      flash.now[:alert] = "There were errors creating the action."
      render_action_form(url: actions_path, method: :post, status: :unprocessable_entity)
    end
  end

  def edit
    render_action_form(url: action_path(@action), method: :patch)
  end

  def update
    if @action.update(action_params)
      redirect_to action_path(@action), notice: "Action was successfully updated."
    else
      flash.now[:alert] = "There were errors updating the action."
      render_action_form(url: action_path(@action), method: :patch, status: :unprocessable_entity)
    end
  end

  def destroy
    @action.destroy
    redirect_to actions_path, notice: "Action was successfully destroyed."
  end

  private

  def set_action
    @action = current_account.actions.find(params[:id])
  end

  def action_params
    params.require(:action_record).permit(:name, :type)
  end

  def render_action_form(url:, method:, status: nil)
    render ActionFormComponent.new(
      action_record: @action,
      url: url,
      method: method,
      action_types: action_types_for_select
    ), status: status
  end

  def action_types_for_select
    # Map class names to user-friendly strings
    # and return as [ [ "Label", "ClassName" ], ... ]
    {
      "ActionSms" => "SMS",
      "ActionWait" => "Wait",
      "ActionPost" => "Snail Mail",
      "ActionEmail" => "Email",
      "ActionNotify" => "Internal Notifier",
      "ActionConnect" => "API"
    }.map { |klass, label| [ label, klass ] }
  end
end
