class GoalRuleGroup < ApplicationRecord
  belongs_to :goal
  belongs_to :rule_group

  enum :state, { initial: 1, end: 3 }
  validates :state, presence: true
end
