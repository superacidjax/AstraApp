class Goal < ApplicationRecord
  belongs_to :account
  has_many :goal_rules
  has_many :rules, through: :goal_rules

  validates :success_rate, presence: true, numericality: true
end
