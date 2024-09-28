class Api::V1::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :api_authenticate

  private

  def api_authenticate
    username = Rails.application.credentials.dig(:basic_auth, :username)
    password = Rails.application.credentials.dig(:basic_auth, :password)
    authenticate_or_request_with_http_basic do |provided_username, provided_password|
      ActiveSupport::SecurityUtils.secure_compare(provided_username, username) &
        ActiveSupport::SecurityUtils.secure_compare(provided_password, password)
    end
  end

  def valid_iso8601_timestamp?(timestamp)
    DateTime.iso8601(timestamp)
    true
  rescue ArgumentError
    false
  end
end
