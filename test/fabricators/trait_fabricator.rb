Fabricator(:trait) do
  account
  name "Generic Trait"
end

Fabricator(:numeric_trait, from: :trait) do
  account
  name { [
    "currentBMI", "currentBpSystolic", "currentBpDiastolic",
    "currentWeightInKg", "currentWaistInCm",
    "currentGlucose", "currentA1c"
  ].sample }
  value_type { "numeric" }
end

Fabricator(:boolean_trait, from: :trait) do
  account
  name { [
    "isActive", "hasCompleted", "isVerified",
    "isSubscribed", "hasPremiumAccess"
  ].sample }
  value_type { "boolean" }
end

Fabricator(:datetime_trait, from: :trait) do
  account
  name { [
    "birthday", "createdAt", "hireDate",
    "lastLogin", "subscriptionEndDate"
  ].sample }
  value_type { "datetime" }
end

Fabricator(:text_trait, from: :trait) do
  account
  name { [
    "firstName", "lastName", "gender",
    "email", "phone", "address",
    "username", "role", "department"
  ].sample }
  value_type { "text" }
end
