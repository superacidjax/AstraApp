Fabricator(:goal_rule) do
  goal
  rule { Fabricate(:person_rule) }
  state { 1 }
end

Fabricator(:initial_goal_rule, from: :goal_rule) do
  state { "initial" }
end

Fabricator(:end_goal_rule, from: :goal_rule) do
  state { "end" }
end
