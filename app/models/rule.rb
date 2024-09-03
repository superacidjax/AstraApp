class Rule < ApplicationRecord
  belongs_to :account
  has_many :client_applications, through: :client_application_rules
  has_many :goals, through: :goal_rules

  validates :name, presence: true, uniqueness: { scope: :account_id }
end
