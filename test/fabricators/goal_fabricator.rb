Fabricator(:goal) do
  account
  name { sequence(:goal_name) { |i| "Goal #{i}" } }
  success_rate { 100.0 }
  description "someDescription"
end
