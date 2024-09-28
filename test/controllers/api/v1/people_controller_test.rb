require "test_helper"

class Api::V1::PeopleControllerTest < ActionDispatch::IntegrationTest
  setup do
    @valid_person = {
      person: {
        user_id: "0191faa2-b4d7-78bc-8cdc-6a4dc176ebb4",
        traits: {
          "firstName" => "Brian",
          "lastName" => "Dear",
          "email" => "brian@example.com",
          "current_bmi" => "21"
        },
        timestamp: "2023-10-25T23:48:46+00:00",
        application_id: client_applications(:one).id
      }
    }
  end

  test "should create person, traits, and trait values with valid data" do
    assert_difference("Person.count", 1) do
      assert_difference("Trait.count", 4) do
        assert_difference("TraitValue.count", 4) do
          post api_v1_people_url, params: @valid_person, as: :json, headers: { Authorization: basic_auth_header }
        end
      end
    end

    assert_response :created

    response_data = JSON.parse(response.body)
    assert_equal @valid_person[:person][:user_id], response_data["client_user_id"]
    assert_equal @valid_person[:person][:traits], response_data["traits"]
    assert_equal @valid_person[:person][:timestamp], response_data["client_timestamp"]
    assert_equal @valid_person[:person][:application_id], response_data["application_id"]

    person = Person.find_by(client_user_id: @valid_person[:person][:user_id])
    assert_not_nil person

    @valid_person[:person][:traits].each do |trait_name, trait_value|
      trait = Trait.find_by(name: trait_name, account_id: person.account_id)
      assert_not_nil trait, "Trait #{trait_name} should exist"
      trait_value_record = TraitValue.find_by(trait_id: trait.id, person_id: person.id)
      assert_not_nil trait_value_record, "TraitValue for #{trait_name} should exist"
      assert_equal trait_value, trait_value_record.data, "TraitValue should match the input value"
    end
  end

  test "should return bad request if user_id is missing" do
    invalid_person = @valid_person.dup
    invalid_person[:person].delete(:user_id)

    post api_v1_people_url, params: invalid_person, as: :json, headers: { Authorization: basic_auth_header }

    assert_response :bad_request
    response_data = JSON.parse(response.body)
    assert_includes response_data["error"], "Missing required parameters: user_id"
  end

  test "should return bad request if traits are missing" do
    invalid_person = @valid_person.dup
    invalid_person[:person].delete(:traits)

    post api_v1_people_url, params: invalid_person, as: :json, headers: { Authorization: basic_auth_header }

    assert_response :bad_request
    response_data = JSON.parse(response.body)
    assert_includes response_data["error"], "Missing required parameters: traits"
  end

  test "should return bad request if timestamp is missing" do
    invalid_person = @valid_person.dup
    invalid_person[:person].delete(:timestamp)

    post api_v1_people_url, params: invalid_person, as: :json, headers: { Authorization: basic_auth_header }

    assert_response :bad_request
    response_data = JSON.parse(response.body)
    assert_includes response_data["error"], "Missing required parameters: timestamp"
  end

  test "should return bad request if application_id is missing" do
    invalid_person = @valid_person.dup
    invalid_person[:person].delete(:application_id)

    post api_v1_people_url, params: invalid_person, as: :json, headers: { Authorization: basic_auth_header }

    assert_response :bad_request
    response_data = JSON.parse(response.body)
    assert_includes response_data["error"], "Missing required parameters: application_id"
  end

  test "should return method not allowed for non-POST requests" do
    [ :get, :put, :patch, :delete ].each do |http_method|
      send(http_method, api_v1_people_url, as: :json, headers: { Authorization: basic_auth_header })
      assert_response :not_found, "Expected #{http_method.upcase} to be rejected with 404"
    end
  end

  private

  def basic_auth_header
    username = Rails.application.credentials.dig(:basic_auth, :username)
    password = Rails.application.credentials.dig(:basic_auth, :password)
    ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
  end
end
