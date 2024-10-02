class RuleGroupRule < ApplicationRecord
  belongs_to :rule
  belongs_to :rule_group

  validates :rule_id, uniqueness: { scope: :rule_group_id, message: "is already associated with this rule group" }
end
