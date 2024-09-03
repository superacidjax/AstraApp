class FlowRecipient < ApplicationRecord
  belongs_to :flow
  belongs_to :last_completed_flow_action, class_name: "FlowAction",
    optional: true, foreign_key: "last_completed_flow_action_id"

  validates :person_id, presence: true, format: { with: /\A[0-9a-fA-F-]{36}\z/,
                                                  message: "must be a valid UUID" }

  enum :status, { active: 5, paused: 10, complete: 15, cancelled: 20 }
  validates :status, presence: true

  validates :is_goal_achieved, inclusion: { in: [ true, false ] }

  def person
    @person ||= Person.find(person_id)
  rescue ActiveResource::ResourceNotFound
    nil
  end
end
