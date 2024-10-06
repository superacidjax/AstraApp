require "test_helper"

class Api::V1::EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @client_application = Fabricate(:client_application)
    @valid_event = {
      event: {
        user_id: "0191faa2-b4d7-78bc-8cdc-6a4dc176ebb4",
        name: "newSubscription",
        application_id: @client_application.id,
        timestamp: "2023-10-05T14:48:00Z",
        properties: {
          "subscription_value" => "930",
          "subscription_type" => "videopass elite"
        }
      }
    }
  end

  test "should create event with valid data" do
    post api_v1_events_url, params: @valid_event, as: :json, headers: { Authorization: basic_auth_header }
    assert_response :created

    response_data = JSON.parse(response.body)
    assert_equal @valid_event[:event][:user_id], response_data["client_user_id"]
    assert_equal @valid_event[:event][:name], response_data["name"]
    assert_equal @valid_event[:event][:application_id], response_data["application_id"]
    assert_equal @valid_event[:event][:timestamp], response_data["client_timestamp"]
    assert_equal @valid_event[:event][:properties], response_data["properties"]
  end

  test "should return bad request if user_id is missing" do
    invalid_event = @valid_event.deep_dup
    invalid_event[:event].delete(:user_id)

    post api_v1_events_url, params: invalid_event, as: :json, headers: { Authorization: basic_auth_header }
    assert_response :bad_request

    response_data = JSON.parse(response.body)
    assert_includes response_data["error"], "Missing required parameters: user_id"
  end

  test "should return bad request if application_id is missing" do
    invalid_event = @valid_event.deep_dup
    invalid_event[:event].delete(:application_id)

    post api_v1_events_url, params: invalid_event, as: :json, headers: { Authorization: basic_auth_header }
    assert_response :bad_request

    response_data = JSON.parse(response.body)
    assert_includes response_data["error"], "Missing required parameters: application_id"
  end

  test "should return bad request if timestamp is missing" do
    invalid_event = @valid_event.deep_dup
    invalid_event[:event].delete(:timestamp)

    post api_v1_events_url, params: invalid_event, as: :json, headers: { Authorization: basic_auth_header }
    assert_response :bad_request

    response_data = JSON.parse(response.body)
    assert_includes response_data["error"], "Missing required parameters: timestamp"
  end

  test "should return bad request if properties are missing" do
    invalid_event = @valid_event.deep_dup
    invalid_event[:event].delete(:properties)

    post api_v1_events_url, params: invalid_event, as: :json, headers: { Authorization: basic_auth_header }
    assert_response :bad_request

    response_data = JSON.parse(response.body)
    assert_includes response_data["error"], "Missing required parameters: properties"
  end

  test "should return bad request if timestamp is not in ISO8601 format" do
    invalid_event = @valid_event.deep_dup
    invalid_event[:event][:timestamp] = "invalid_timestamp"

    post api_v1_events_url, params: invalid_event, as: :json, headers: { Authorization: basic_auth_header }
    assert_response :bad_request

    response_data = JSON.parse(response.body)
    assert_includes response_data["error"], "Invalid timestamp format. It must be in ISO8601 format."
  end

  test "should return not found for GET requests" do
    get api_v1_events_url, headers: { Authorization: basic_auth_header }
    assert_response :not_found
  end

  test "should return not found for PUT requests" do
    put api_v1_events_url, params: @valid_event, as: :json, headers: { Authorization: basic_auth_header }
    assert_response :not_found
  end

  test "should return not found for DELETE requests" do
    delete api_v1_events_url, headers: { Authorization: basic_auth_header }
    assert_response :not_found
  end

  private

  def basic_auth_header
    username = Rails.application.credentials.dig(:basic_auth, :username)
    password = Rails.application.credentials.dig(:basic_auth, :password)
    ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
  end
end
