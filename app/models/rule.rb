class Rule < ApplicationRecord
  belongs_to :account
  has_many :goal_rules, dependent: :destroy
  has_many :goals, through: :goal_rules
  has_many :rule_groups
  has_many :rule_groups, through: :rule_group_rules

  validates :name, presence: true, uniqueness: { scope: :account_id }
  validates :rule_data, presence: true
end
