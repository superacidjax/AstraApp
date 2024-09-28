account = Account.create!(name: "AstraGoalTestAccount")
client_app = ClientApplication.create!(
  name: "AstraTest",
  account_id: account.id
)
