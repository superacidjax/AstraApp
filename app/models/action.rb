class Action < ApplicationRecord
  belongs_to :account
  has_many :flow_actions
  has_many :flows, through: :flow_actions

  validates :name, presence: true

  private

  def ensure_subclass
    if self.class == Action
      errors.add(:base, "Cannot instantiate abstract class Action directly")
    end
  end
end
