class TraitValue < ApplicationRecord
  belongs_to :person
  belongs_to :trait

  validates :data, presence: true
end
