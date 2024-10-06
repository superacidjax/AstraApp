Fabricator(:flow) do
  account
  name { sequence(:flow_name) { |i| "Flow #{i}" } }
end
