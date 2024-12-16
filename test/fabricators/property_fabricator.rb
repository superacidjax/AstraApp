Fabricator(:property) do
  event
  name { [ "date_of_lab", "test_type", "result", "source" ].sample }
end

Fabricator(:numeric_property, from: :property) do
  event
  name { [
    "result", "score", "quantity", "amount", "rating",
    "level", "index", "duration", "frequency", "speed"
  ].sample }
  is_active true
  value_type { "numeric" }
end

Fabricator(:boolean_property, from: :property) do
  event
  name { [
    "isApproved", "isProcessed", "hasVerified",
    "isActive", "hasAccess", "isEnabled",
    "hasCompleted", "isVisible", "isArchived", "isDeleted"
  ].sample }
  is_active true
  value_type { "boolean" }
end

Fabricator(:datetime_property, from: :property) do
  event
  name { [
    "date_of_claim", "date_of_lab", "subscription_end",
    "last_updated", "event_start", "event_end",
    "registration_date", "expiration_date", "review_date",
    "completion_date"
  ].sample }
  is_active true
  value_type { "datetime" }
end

Fabricator(:text_property, from: :property) do
  event
  name { [
    "test_type", "source", "description",
    "category", "status", "location",
    "comments", "remarks", "notes", "type"
  ].sample }
  is_active true
  value_type { "text" }
end
