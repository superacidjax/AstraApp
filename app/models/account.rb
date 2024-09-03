class Account < ApplicationRecord
  has_many :client_applications
  has_many :flows
  has_many :goals
  has_many :rules
  has_many :account_users
  has_many :users, through: :account_users

  validates :name, presence: true
end
