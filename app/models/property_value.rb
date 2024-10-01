class PropertyValue < ApplicationRecord
  belongs_to :property

  validates :data, presence: true
end
