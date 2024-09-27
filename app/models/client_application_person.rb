class ClientApplicationPerson < ApplicationRecord
  belongs_to :person
  belongs_to :client_application
end
