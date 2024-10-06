Fabricator(:client_application) do
  name { sequence(:client_app_name) { |i| "Client Application #{i}" } }
  account
end
