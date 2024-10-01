class Event < ApplicationRecord
  belongs_to :client_application
  has_many :properties, dependent: :destroy
  has_many :property_values, dependent: :destroy
  has_many :properties, through: :property_values

  validates :client_timestamp, presence: :true

  def account
    client_application.account
  end
end
