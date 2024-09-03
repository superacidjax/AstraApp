class Event < ActiveResource::Base
  self.site = ENV.fetch("EVENTS_API_URL", "http://localhost:4000")

  # Define the fields accessible by the model
  schema do
    string "event_name"
    datetime "datetime"
    string "client_application_id"
  end
end
