class ClientApplication < ApplicationRecord
  belongs_to :account
  has_many :client_application_people
  has_many :people, through: :client_application_people
  has_many :traits

  validates :name, presence: true, uniqueness: { scope: :account_id }
end
