class Goal < ApplicationRecord
  belongs_to :account
  has_many :goal_rules, dependent: :destroy
  has_many :rules, through: :goal_rules

  accepts_nested_attributes_for :goal_rules, allow_destroy: true

  validates :name, presence: true
  validates :success_rate, presence: true, numericality: true
  validate :exactly_two_goal_rules_with_correct_states

  private

  def exactly_two_goal_rules_with_correct_states
    if goal_rules.size != 2
      errors.add(:goal_rules, "must have exactly two GoalRules")
      return
    end

    states = goal_rules.map(&:state)
    unless states.include?("initial") && states.include?("end")
      errors.add(:goal_rules, "must include one 'initial' and one 'end' GoalRule")
    end
  end
end
