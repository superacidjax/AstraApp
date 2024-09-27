class ClientApplicationEvent < ApplicationRecord
  belongs_to :client_application
  belongs_to :event
end
