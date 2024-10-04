class RuleGroupRule < ApplicationRecord
  belongs_to :rule
  belongs_to :rule_group

  validates :rule_id, uniqueness: { scope: :rule_group_id, message: "is already associated with this rule group" }
  validates :operator, presence: true, inclusion: { in: %w[AND OR NOT] }, unless: :last_item?

  # maybe this should be private?

  def last_item?
    operator.nil?
  end
end
