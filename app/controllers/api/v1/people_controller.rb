class Api::V1::PeopleController < Api::V1::ApiController
  def create
    required_params = %w[ user_id traits timestamp application_id ]
    missing_params = required_params.select { |param| params[param].blank? }

    if missing_params.any?
      render json: { error: "Missing required parameters: #{missing_params.join(', ')}" }, status: :bad_request
      return
    end

    unless valid_iso8601_timestamp?(params[:timestamp])
      render json: { error: "Invalid timestamp format. It must be in ISO8601 format." }, status: :bad_request
      return
    end


    permitted_traits = params[:traits].permit!

    person = {
      client_user_id: params[:user_id],
      traits: permitted_traits.to_h,
      client_timestamp: params[:timestamp],
      application_id: params[:application_id]
    }

    PersonProcessorJob.perform_later(person)
    render json: person, status: :created
  end
end
