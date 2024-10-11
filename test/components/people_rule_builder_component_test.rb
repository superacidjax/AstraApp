require "test_helper"

class PeopleRuleBuilderComponentTest < ViewComponent::TestCase
  setup do
    @account = Fabricate(:account)

    # Fabricate client applications and traits
    @client_application1 = Fabricate(:client_application, account: @account)
    @client_application2 = Fabricate(:client_application, account: @account)

    @trait1 = Fabricate(:trait, name: "First Name", account: @account)
    @trait2 = Fabricate(:trait, name: "Last Name", account: @account)

    @client_application1.traits << @trait1
    @client_application2.traits << @trait2

    @component = PeopleRuleBuilderComponent.new(
      account: @account,
      traits: @account.traits,
      client_applications: @account.client_applications
    )
  end

  test "renders client applications" do
    result = render_inline(@component)

    client_app_options = result.css("select#client_applications option").map { |option| option.text.strip }
    assert_includes client_app_options, @client_application1.name
    assert_includes client_app_options, @client_application2.name
  end

  test "renders trait dropdown with 'Select a trait' option" do
    result = render_inline(@component)

    trait_options = result.css("select#traits option").map { |option| option.text.strip }
    assert_includes trait_options, "Select a trait"
  end

  test "renders the 'All Applications' option" do
    render_inline(@component)
    assert_selector("select#client_applications option", text: "All Applications")
  end
end
