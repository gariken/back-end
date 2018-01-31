class Api::V1::CoordinatesController < Api::V1::ApiController

  def show
    render json: { data: { coordinates: Geocoder.coordinates(params[:address]) } }
  end
end
