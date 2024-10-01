class Goal < ApplicationRecord
  belongs_to :account
  has_many :goal_rules, dependent: :destroy
  has_many :rules, through: :goal_rules

  validates :name, presence: true
  validates :success_rate, presence: true, numericality: true
end
