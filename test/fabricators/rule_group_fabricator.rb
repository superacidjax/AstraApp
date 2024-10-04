Fabricator(:rule_group) do
  account
  name { sequence(:rule_group_name) { |i| "Rule Group #{i}" } }
  data do
    {
      "items" => [
        {
          "type" => "rule",
          "rule_id" => Fabricate(:trait_rule).id,
          "operator" => "AND"
        }
      ]
    }
  end
end
