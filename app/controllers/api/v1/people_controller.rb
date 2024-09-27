class Api::V1::PeopleController < ApplicationController
  before_action :authenticate

  def create
    required_params = %w[ user_id traits timestamp application_id ]
    missing_params = required_params.select { |param| params[param].blank? }

    if missing_params.any?
      render json: { error: "Missing required parameters: #{missing_params.join(', ')}" }, status: :bad_request
      return
    end

    unless params[:traits].is_a?(ActionController::Parameters) && params[:traits].present?
      render json: { error: "Traits must be a non-empty hash" }, status: :bad_request
      return
    end

    permitted_traits = params[:traits].permit!

    person = {
      user_id: params[:user_id],
      traits: permitted_traits.to_h,
      timestamp: params[:timestamp],
      application_id: params[:application_id]
    }

    PersonProcessorJob.perform_later(person)
    render json: person, status: :created
  end

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
