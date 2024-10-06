Fabricator(:person) do
  account
  client_user_id { sequence(:client_user_id) { |i| "client_user_#{i}" } }
  client_timestamp { Time.current }
end
