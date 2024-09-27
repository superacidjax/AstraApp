class ClientApplicationProperty < ApplicationRecord
  belongs_to :property
  belongs_to :client_application
end
