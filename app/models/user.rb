class User < ApplicationRecord
  has_many :account_users
  has_many :accounts, through: :account_users

  validates :email, presence: true, uniqueness: true,
    format: { with: VALID_EMAIL_REGEX, message: "must be a valid email address" }
end
