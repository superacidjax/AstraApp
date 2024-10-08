class Goal < ApplicationRecord
  belongs_to :account
  has_many :goal_rules, dependent: :destroy
  has_many :rules, through: :goal_rules
  has_many :goal_rule_groups, dependent: :destroy
  has_many :rule_groups, through: :goal_rule_groups

  accepts_nested_attributes_for :goal_rules, allow_destroy: true
  accepts_nested_attributes_for :goal_rule_groups, allow_destroy: true

  validates :name, presence: true
  validates :success_rate, presence: true, numericality: true
  validates :data, presence: true
  validates_with GoalDataValidator

  jsonb_accessor :data,
    initial_state: :jsonb,
    end_state: :jsonb
end
