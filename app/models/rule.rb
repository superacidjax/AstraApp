class Rule < ApplicationRecord
  belongs_to :account
  has_many :goal_rules, dependent: :destroy
  has_many :goals, through: :goal_rules

  validates :name, presence: true, uniqueness: { scope: :account_id }
end
