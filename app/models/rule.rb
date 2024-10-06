class Rule < ApplicationRecord
  belongs_to :account
  belongs_to :ruleable, polymorphic: true

  has_many :goal_rules, dependent: :destroy
  has_many :goals, through: :goal_rules
  has_many :rule_groups
  has_many :rule_group_rules
  has_many :rule_groups, through: :rule_group_rules

  validates :name, presence: true, uniqueness: { scope: :account_id }
  validates :data, presence: true
  validates_with RuleDataValidator

  jsonb_accessor :data,
    operator: :string,       # Operator for comparison (e.g., "Is", "Greater than")
    value: :string,          # Unified field for both trait and property values
    from: :string,           # For range-based rules
    to: :string,             # For range-based rules
    inclusive: :boolean      # For specifying if the range is inclusive
end
