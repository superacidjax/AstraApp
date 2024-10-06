Fabricator(:trait) do
  account
  name { sequence(:trait_name) { |i| "Trait #{i}" } }
  value_type { 0 }
  is_active { true }
end
