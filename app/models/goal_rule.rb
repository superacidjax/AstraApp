class GoalRule < ApplicationRecord
  belongs_to :goal
  belongs_to :rule, inverse_of: :goal_rules

  accepts_nested_attributes_for :rule

  enum :state, { initial: 1, end: 3 }
  validates :state, presence: true
  validates :rule_id, uniqueness: { scope: :goal_id, message: "Rule has already been added to this Goal" }
end
