class Flow < ApplicationRecord
  belongs_to :account
  has_many :people
  has_many :flow_recipients, dependent: :destroy
  has_many :people, through: :flow_recipients
  has_many :flow_goals, dependent: :destroy
  has_many :goals, through: :flow_goals
  has_many :flow_actions, dependent: :destroy
  has_many :actions, through: :flow_actions

  accepts_nested_attributes_for :flow_goals, allow_destroy: true
  accepts_nested_attributes_for :flow_actions, allow_destroy: true

  validates :name, presence: true, uniqueness: { scope: :account_id }
end
