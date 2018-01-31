class Api::V1::AddressesController < Api::V1::ApiController

  def show
    geo_object = Geocoder.search([params[:lat].to_f, params[:lon].to_f])
    address = geo_object.first.address unless geo_object.blank? || geo_object.first.nil?
    render json: { data: { address: address } }
  end

  def autocomplete
    render json: { data: { result: GoogleMaps.autocomplete(params[:input], params[:location]) } }
  end
end
