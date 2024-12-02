Fabricator(:event_rule, from: :rule) do
  account
  name { Faker::Company.bs }
  type { "EventRule" }
  ruleable { Fabricate(:property) }
end

Fabricator(:numeric_event_rule, from: :rule) do
  account
  name { Faker::Company.bs }
  type { "EventRule" }
  operator "Greater than"
  value "50"
  ruleable { Fabricate(:numeric_property, event: Fabricate(:event)) }
end

Fabricator(:text_event_rule, from: :rule) do
  account { Fabricate(:account) }
  name { Faker::Company.bs }
  type { "EventRule" }
  ruleable { Fabricate(:text_property, event: event) }
end

Fabricator(:boolean_event_rule, from: :rule) do
  account { Fabricate(:account) }
  name { Faker::Company.bs }
  type { "EventRule" }
  ruleable { Fabricate(:boolean_property, event: event) }
end

Fabricator(:datetime_event_rule, from: :rule) do
  account { Fabricate(:account) }
  name { Faker::Company.bs }
  type { "EventRule" }
  ruleable { Fabricate(:datetime_property, event: event) }
end

Fabricator(:occurrence_event_rule, from: :rule) do
  account { Fabricate(:account) }
  name { Faker::Company.bs }
  type { "EventRule" }
  ruleable { Fabricate(:property, event: event) }
end
