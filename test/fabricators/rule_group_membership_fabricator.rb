Fabricator(:rule_group_membership) do
  parent_group { Fabricate(:rule_group) }
  child_group { Fabricate(:rule_group) }
  operator { "AND" }
end
