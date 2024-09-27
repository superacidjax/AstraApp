class Account < ApplicationRecord
  has_many :client_applications, dependent: :destroy
  has_many :flows, dependent: :destroy
  has_many :goals, dependent: :destroy
  has_many :rules, dependent: :destroy
  has_many :account_users, dependent: :destroy
  has_many :users, through: :account_users
  has_many :traits, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
