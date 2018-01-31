require 'acceptance_helper'

resource "Routes", acceptance: true do

  get "/api/v1/routes" do
    parameter :lat_from, "latitude(decimal)"
    parameter :lon_from, "longitude(decimal)"
    parameter :lat_to, "latitude(decimal)"
    parameter :lon_to, "longitude(decimal)"

    example "Get mapbox object", document: :private do
      explanation "Get mapbox object"

      do_request({lat_from: 55.82173, lat_to: 55.766101, lon_from: 37.660269, lon_to: 37.640075})
      expect(status).to eq 200
    end
  end

end
