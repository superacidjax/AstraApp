class Property < ApplicationRecord
  belongs_to :account
  has_many :client_applications
  has_many :client_application_properties, dependent: :destroy
  has_many :client_applications, through: :client_application_properties
  has_many :events
  has_many :property_values, dependent: :destroy
  has_many :events, through: :property_values

  validates :name, presence: true
  validates_inclusion_of :is_active, in: [ true, false ]
  validates :value_type, presence: true

  enum :value_type, { text: 0, numeric: 1, boolean: 2, datetime: 3 }
end
