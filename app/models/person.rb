class Person < ApplicationRecord
  belongs_to :account
  has_many :client_application_people, dependent: :destroy
  has_many :client_applications, through: :client_application_people
  has_many :flows
  has_many :flows, through: :flow_recipients
  has_many :traits
  has_many :trait_values, dependent: :destroy
  has_many :traits, through: :trait_values

  validates :client_timestamp, presence: true
  validates :client_user_id, presence: true
end
