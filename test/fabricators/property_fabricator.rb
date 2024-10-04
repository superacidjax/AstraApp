Fabricator(:property) do
  event
  name { sequence(:property_name) { |i| "Property #{i}" } }
  is_active { true }
  value_type { 0 }
end
