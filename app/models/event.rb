class Event < ApplicationRecord
  belongs_to :client_application
  has_many :properties, dependent: :destroy

  validates :client_timestamp, presence: :true

  def account
    client_application.account
  end
end
