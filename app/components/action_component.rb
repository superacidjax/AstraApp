class ActionComponent < ViewComponent::Base
  ACTION_TYPE_LABELS = {
    "ActionSms" => "SMS",
    "ActionWait" => "Wait",
    "ActionPost" => "Snail Mail",
    "ActionEmail" => "Email",
    "ActionNotify" => "Internal Notifier",
    "ActionConnect" => "API"
  }.freeze

  def initialize(action_record:)
    @action_record = action_record
  end

  def display_action_type
    ACTION_TYPE_LABELS[@action_record.type] || @action_record.type
  end
end
