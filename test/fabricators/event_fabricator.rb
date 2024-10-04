Fabricator(:event) do
  client_application
  name { sequence(:event_name) { |i| "Event #{i}" } }
  client_user_id { sequence(:client_user_id) { |i| "user_#{i}" } }
  client_timestamp { Time.current }
end
