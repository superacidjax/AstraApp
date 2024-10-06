Fabricator(:account) do
  name { sequence(:account_name) { |i| "Account #{i}" } }
end
