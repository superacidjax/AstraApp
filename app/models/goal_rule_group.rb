class GoalRuleGroup < ApplicationRecord
  belongs_to :goal
  belongs_to :rule_group

  accepts_nested_attributes_for :rule_group, allow_destroy: true

  enum :state, { initial: 1, end: 3 }
  validates :state, presence: true
end
