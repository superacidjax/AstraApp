Fabricator(:action) do
  account
  name { sequence(:action_name) { |i| "Action #{i}" } }
  type { "Action" }
  data { {} }
end

Fabricator(:action_sms) do
  account
  name { sequence(:action_name) { |i| "Action #{i}" } }
  type "ActionSms"
  data { {} }
end

Fabricator(:action_wait) do
  account
  name { sequence(:action_name) { |i| "Action #{i}" } }
  type "ActionWait"
  data { {} }
end
