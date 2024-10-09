require "test_helper"

class TraitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = Fabricate(:account)
    @client_application1 = Fabricate(:client_application,
      account: @account)
    @client_application2 = Fabricate(:client_application,
      account: @account)
    @other_client_application = Fabricate(:client_application,
      account: @account)

    @traits_app1 = Fabricate(:trait, account: @account)
    @client_application1.traits << @traits_app1

    @traits_app2 = Fabricate(:trait, account: @account)
    @client_application2.traits << @traits_app2

    @unrelated_trait = Fabricate(:trait, account: @account)
    @other_client_application.traits << @unrelated_trait
  end

  test "should fetch traits for given client application ids" do
    get traits_url, params: {
      client_application_ids: [ @client_application1.id,
                                @client_application2.id ].join(",")
    }

    assert_response :success
    json_response = JSON.parse(response.body)

    assert_equal 2, json_response.size
    assert_equal @traits_app1.name, json_response.first["name"]
  end

  test "should return empty array if no client applications are passed" do
    get traits_url, params: { client_application_ids: "" }

    assert_response :success
    json_response = JSON.parse(response.body)

    assert_equal 0, json_response.size
  end

  test "should not return traits from unrelated client applications" do
    get traits_url, params: {
      client_application_ids: [ @client_application1.id,
                                @client_application2.id ].join(",")
    }

    assert_response :success
    json_response = JSON.parse(response.body)

    unrelated_trait_ids = [ @unrelated_trait.id ]
    json_response_trait_ids = json_response.map { |trait| trait["id"] }

    assert (json_response_trait_ids & unrelated_trait_ids).empty?,
      "Traits from unrelated client applications should not be returned"
  end
end
