class Goal < ApplicationRecord
  belongs_to :account

  validates :success_rate, presence: true, numericality: true
end
