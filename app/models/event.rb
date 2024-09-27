class Event < ApplicationRecord
  belongs_to :account
  has_many :client_application_events, dependent: :destroy
  has_many :client_applications, through: :client_application_events
  has_many :properties, dependent: :destroy
  has_many :property_values, dependent: :destroy
  has_many :properties, through: :property_values

  validates :client_timestamp, presence: :true
end
