class FlowGoal < ApplicationRecord
  belongs_to :flow
  belongs_to :goal

  validates :success_rate, presence: true, numericality: true
end
