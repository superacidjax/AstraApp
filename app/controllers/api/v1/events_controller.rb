class Api::V1::EventsController < Api::V1::ApiController
  def create
    required_params = %w[ name user_id application_id timestamp properties ]
    missing_params = required_params.select { |param| params[:event][param].blank? }

    if missing_params.any?
      render json: { error: "Missing required parameters: #{missing_params.join(', ')}" }, status: :bad_request
      return
    end

    unless valid_iso8601_timestamp?(params[:event][:timestamp])
      render json: { error: "Invalid timestamp format. It must be in ISO8601 format." }, status: :bad_request
      return
    end

    permitted_properties = params[:event][:properties].permit!

    event = {
      name: params[:event][:name],
      client_user_id: params[:event][:user_id],
      application_id: params[:event][:application_id],
      client_timestamp: params[:event][:timestamp],
      properties: permitted_properties.to_h
    }

    EventProcessorJob.perform_later(event)
    render json: event, status: :created
  end
end
