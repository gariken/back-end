require 'rails_helper'

RSpec.describe Api::V1::RoutesController, type: :controller do

  describe "GET #show" do
    it "returns mapbox object" do
      get :show, params: {lat_from: 55.82173, lat_to: 55.766101, lon_from: 37.660269, lon_to: 37.640075}
      resp = JSON.parse(response.body)
      expect(resp['data']['routes']).not_to eq(nil)
    end
  end
end
