class Trait < ApplicationRecord
  belongs_to :account
  belongs_to :client_application
  has_many :people
  has_many :people, through: :trait_values

  validates :name, presence: true
  validates_inclusion_of :is_active, in: [ true, false ]
  validates :value_type, presence: true

  enum :value_type, { text: 0, numeric: 1, boolean: 2, datetime: 3 }
end
