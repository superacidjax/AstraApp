class RuleGroup < ApplicationRecord
  belongs_to :account

  has_many :rule_group_rules, dependent: :destroy
  has_many :rules, through: :rule_group_rules
  has_many :rule_group_memberships, foreign_key: :parent_group_id,
    class_name: "RuleGroupMembership", dependent: :destroy
  has_many :child_groups, through: :rule_group_memberships, source: :child_group

  validates :name, presence: true
  validate :must_have_rule_or_group

  private

  def must_have_rule_or_group
    items = data["items"] if data.is_a?(Hash)
    if items.blank? || !items.is_a?(Array) || items.empty?
      errors.add(:data, "must contain at least one rule or rule group")
    end
  end
end
