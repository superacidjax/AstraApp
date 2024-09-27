class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :authenticate

  private

  def authenticate
    username = Rails.application.credentials.dig(:basic_auth, :username)
    password = Rails.application.credentials.dig(:basic_auth, :password)
    authenticate_or_request_with_http_basic do |provided_username, provided_password|
      ActiveSupport::SecurityUtils.secure_compare(provided_username, username) &
        ActiveSupport::SecurityUtils.secure_compare(provided_password, password)
    end
  end
end
