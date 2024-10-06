class RuleGroupMembership < ApplicationRecord
  belongs_to :parent_group, class_name: "RuleGroup", foreign_key: :parent_group_id
  belongs_to :child_group, class_name: "RuleGroup", foreign_key: :child_group_id

  validates :child_group_id, uniqueness: { scope: :parent_group_id, message: "is already added to this parent group" }
  validates :operator, presence: true, inclusion: { in: %w[AND OR NOT] }, unless: :last_item?

  def last_item?
    operator.nil?
  end
end
