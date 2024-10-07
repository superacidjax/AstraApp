class RuleGroup < ApplicationRecord
  belongs_to :account

  has_many :rule_group_rules, dependent: :destroy
  has_many :rules, through: :rule_group_rules
  has_many :rule_group_memberships, foreign_key: :parent_group_id,
    class_name: "RuleGroupMembership", dependent: :destroy
  has_many :child_groups, through: :rule_group_memberships, source: :child_group

  accepts_nested_attributes_for :rule_group_rules, allow_destroy: true
  accepts_nested_attributes_for :rule_group_memberships, allow_destroy: true

  validates :name, presence: true
end
