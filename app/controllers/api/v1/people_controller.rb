class Api::V1::PeopleController < Api::V1::ApiController
  def create
    required_params = %w[ user_id traits timestamp application_id ]
    missing_params = required_params.select { |param| params[:person][param].blank? }

    if missing_params.any?
      render json: { error: "Missing required parameters: #{missing_params.join(', ')}" }, status: :bad_request
      return
    end

    unless valid_iso8601_timestamp?(params[:person][:timestamp])
      render json: { error: "Invalid timestamp format. It must be in ISO8601 format." }, status: :bad_request
      return
    end


    permitted_traits = params[:person][:traits].permit!

    person = {
      client_user_id: params[:person][:user_id],
      traits: permitted_traits.to_h,
      client_timestamp: params[:person][:timestamp],
      application_id: params[:person][:application_id]
    }

    PersonProcessorJob.perform_later(person)
    render json: person, status: :created
  end
end
