require "test_helper"

class PeopleRuleBuilderComponentTest < ViewComponent::TestCase
  setup do
    @account = Fabricate(:account)

    # Fabricate client applications and traits
    @client_application1 = Fabricate(:client_application, account: @account)
    @client_application2 = Fabricate(:client_application, account: @account)

    @trait1 = Fabricate(:trait, name: "First Name")
    @trait2 = Fabricate(:trait, name: "Last Name")

    @client_application1.traits << @trait1
    @client_application2.traits << @trait2

    @component = PeopleRuleBuilderComponent.new(account: @account)
  end

  test "renders the component with client applications and traits" do
    # Render the component inline
    result = render_inline(@component)

    client_app_options = result.css("select#client_applications option").map { |option| option.text.strip }
    assert_includes client_app_options, @client_application1.name
    assert_includes client_app_options, @client_application2.name

    trait_options = result.css("select#traits option").map { |option| option.text.strip }

    # Checking for the rendered traits (all should be rendered, filtering is a Stimulus responsibility)
    assert_includes trait_options, "First Name"
    assert_includes trait_options, "Last Name"
  end

  test "renders the 'All Applications' option" do
    render_inline(@component)

    assert_selector("select#client_applications option", text: "All Applications")
  end
end
