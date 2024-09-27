class FlowRecipient < ApplicationRecord
  belongs_to :flow
  belongs_to :person
  belongs_to :last_completed_flow_action, class_name: "FlowAction",
    optional: true, foreign_key: "last_completed_flow_action_id"

  validates :person_id, presence: true

  enum :status, { active: 5, paused: 10, complete: 15, cancelled: 20 }
  validates :status, presence: true

  validates :is_goal_achieved, inclusion: { in: [ true, false ] }
end
