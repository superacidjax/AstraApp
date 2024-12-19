class FlowAction < ApplicationRecord
  belongs_to :action
  belongs_to :flow

  before_validation :set_type_from_action

  ACTION_TO_FLOW_ACTION_MAP = {
    "ActionSms" => "FlowActionSms",
    "ActionWait" => "FlowActionWait",
    "ActionPost" => "FlowActionPost",
    "ActionEmail" => "FlowActionEmail",
    "ActionNotify" => "FlowActionNotify",
    "ActionConnect" => "FlowActionConnect"
  }.freeze

  private

  def set_type_from_action
    return if action.blank?
    self.type = ACTION_TO_FLOW_ACTION_MAP[action.type]
  end
end
