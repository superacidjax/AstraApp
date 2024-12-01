class Trait < ApplicationRecord
  belongs_to :account
  has_many :client_applications
  has_many :client_application_traits
  has_many :client_applications, through: :client_application_traits
  has_many :people
  has_many :trait_values, dependent: :destroy
  has_many :people, through: :trait_values
  has_many :person_rules, as: :ruleable, dependent: :destroy

  validates :name, presence: true
  validates_inclusion_of :is_active, in: [ true, false ]
  validates :value_type, presence: true

  enum :value_type, { text: 0, numeric: 1, boolean: 2, datetime: 3 }
end
