class Person < ActiveResource::Base
  self.site = ENV.fetch("PERSONS_API_URL", "http://localhost:4000")

  # Define the fields accessible by the model
  schema do
    string "email_address"
    datetime "datetime"
    string "sms_number"
    string "first_name"
    string "last_name"
    string "client_application_id"
    string "id"
  end
end
