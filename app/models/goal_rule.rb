class GoalRule < ApplicationRecord
  belongs_to :goal
  belongs_to :rule

  enum :state, { initial: 1, end: 3 }
  validates :state, presence: true
end
