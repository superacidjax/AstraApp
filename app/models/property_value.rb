class PropertyValue < ApplicationRecord
  belongs_to :event
  belongs_to :property

  validates :data, presence: true
end
