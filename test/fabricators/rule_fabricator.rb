Fabricator(:rule) do
  account
  name { sequence(:rule_name) { |i| "Rule #{i}" } }
  data { { some: "valid data" } }
end

# rule fabricator (for trait-based rule)
Fabricator(:trait_rule, from: :rule) do
  account
  ruleable { Fabricate(:trait) }
  data { { operator: "Equals", value: "some value" } }
end

# rule fabricator (for property-based rule)
Fabricator(:property_rule, from: :rule) do
  account
  ruleable { Fabricate(:property) }
  data { { operator: "Equals", value: "some value" } }
end
