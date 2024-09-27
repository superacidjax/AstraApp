class Flow < ApplicationRecord
  belongs_to :account
  has_many :people
  has_many :flow_recipients
  has_many :people, through: :flow_recipients

  validates :name, presence: true, uniqueness: { scope: :account_id }
end
