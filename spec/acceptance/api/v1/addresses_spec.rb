require 'acceptance_helper'

resource "Addresses", acceptance: true do

  get "/api/v1/addresses" do
    parameter :lat, "Latitude"
    parameter :lon, "Longitude"

    example "Get address", document: :private do
      explanation "Get address"

      do_request({lat: 55.82173, lon: 37.660269})
      expect(status).to eq 200
    end
  end

  get "/api/v1/addresses/autocomplete" do
    parameter :input, "search address"
    parameter :location, "user location (string 'lat, lon') optional"

    example "Get addresses for autocomplete", document: :private do
      explanation "Get addresses for autocomplete"

      do_request({input: "Магас, ул"})
      expect(status).to eq 200
    end
  end

end
