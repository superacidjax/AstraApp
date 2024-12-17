class Action < ApplicationRecord
  belongs_to :account
  has_many :flow_actions
  has_many :flows, through: :flow_actions

  validates :name, presence: true
end
