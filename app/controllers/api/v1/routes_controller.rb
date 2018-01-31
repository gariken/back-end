class Api::V1::RoutesController < Api::V1::ApiController

  def show
    render json: { data: Mapbox.route(params[:lat_from], params[:lon_from], params[:lat_to], params[:lon_to]) }
  end
end
