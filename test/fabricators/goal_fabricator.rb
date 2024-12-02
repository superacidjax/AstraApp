Fabricator(:goal) do
  account
  name { sequence(:goal_name) { |i| "Goal #{i}" } }
  success_rate { 100.0 }
  description { Faker::Lorem.paragraph }
end

Fabricator(:goal_with_rules, from: :goal) do
  after_build do |goal|
    event_rule = Fabricate(:numeric_event_rule, account: account)
    goal.goal_rules.build(state: "initial", rule: event_rule)
    person_rule = Fabricate(:person_rule, account: account)
    goal.goal_rules.build(state: "end", rule: person_rule)
  end
end
