class TraitsController < ApplicationController
  def index
    if params[:client_application_ids].present?
      client_application_ids = params[:client_application_ids].split(",")
      traits = Trait.joins(:client_application_traits)
                    .where(client_application_traits: { client_application_id: client_application_ids })
                    .distinct
    else
      traits = Trait.none
    end

    render json: traits
  end
end
