class Rule < ApplicationRecord
  belongs_to :account
  belongs_to :ruleable, polymorphic: true

  has_many :goal_rules, dependent: :destroy
  has_many :goals, through: :goal_rules
  has_many :rule_groups
  has_many :rule_group_rules
  has_many :rule_groups, through: :rule_group_rules

  validates :name, presence: true, uniqueness: { scope: :account_id }
<<<<<<< Updated upstream
  validates :data, presence: true
  validates_with EventRuleDataValidator, if: :event_rule?
  validates_with PersonRuleDataValidator, if: :person_rule?

  jsonb_accessor :data,
    # For Person-based and Event-based rule comparisons (trait/property)
    trait_operator: :string,        # Operator for trait (e.g., "Greater than", "Equals")
    trait_value: :string,           # Value for trait comparison
    trait_from: :string,            # For range-based trait rules
    trait_to: :string,              # For range-based trait rules
    trait_inclusive: :boolean,      # Inclusive/exclusive range for traits

    property_operator: :string,     # Operator for properties in event-based rules
    property_value: :string,        # Value for property comparison
    property_from: :string,         # For range-based property rules
    property_to: :string,           # For range-based property rules
    property_inclusive: :boolean,   # Inclusive/exclusive range for properties

    # Event Occurrence-related fields (for event-based rules only)
    occurrence_operator: :string,   # "Has occurred" or "Has not occurred"
    time_unit: :string,             # Time unit (e.g., "hours", "days", "months", "years")
    time_value: :integer,           # Number of time units (e.g., "10" for 10 days)
    datetime_from: :datetime,       # Specific datetime for 'Since' or start of datetime range
    datetime_to: :datetime,         # Specific datetime for end of datetime range
    occurrence_inclusive: :boolean  # Inclusive/exclusive datetime range for events

  private

  def event_rule?
    ruleable_type == "Property"
  end

  def person_rule?
    ruleable_type == "Trait"
  end
=======
  validates :rule_data, presence: true
>>>>>>> Stashed changes
end
