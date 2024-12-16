class Rule < ApplicationRecord
  belongs_to :account
  belongs_to :ruleable, polymorphic: true

  has_many :goal_rules, dependent: :destroy, inverse_of: :rule
  has_many :goals, through: :goal_rules

  validates :name, presence: true, uniqueness: { scope: :account_id }
  validates :data, presence: true
  validates :ruleable, presence: true
  validate :ensure_subclass

  jsonb_accessor :data,
    operator: :string,       # Operator (e.g., "Greater than", "Equals")
    value: :string,          # Value for comparison
    from: :string,           # For range-based rules
    to: :string,             # For range-based rules
    inclusive: :boolean,     # Inclusive/exclusive range
    case_sensitive: :boolean,  # for text case sensitivity

    # Event Occurrence-related fields (specific to EventRule)
    occurrence_operator: :string,    # "Has occurred" or "Has not occurred"
    time_unit: :string,              # e.g., "hours", "days"
    time_value: :integer,            # e.g., 10 for 10 days
    datetime_from: :datetime,        # Start of datetime range
    datetime_to: :datetime,          # End of datetime range
    occurrence_inclusive: :boolean    # Inclusive/exclusive datetime range

  private

  def ensure_subclass
    if self.class == Rule
      errors.add(:base, "Cannot instantiate abstract class Rule directly")
    end
  end
end
