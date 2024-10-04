Fabricator(:action) do
  account
  name { sequence(:action_name) { |i| "Action #{i}" } }
  type { "Action" }
  data { {} }
end
