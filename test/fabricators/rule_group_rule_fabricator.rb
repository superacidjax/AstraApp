Fabricator(:rule_group_rule) do
  rule_group
  rule { Fabricate(:property_rule) }
  operator { "AND" }
end
