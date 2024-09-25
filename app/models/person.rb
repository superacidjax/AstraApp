class Person < ApplicationRecord
  belongs_to :account
  has_many :client_application_people
  has_many :client_applications, through: :client_application_people
end
